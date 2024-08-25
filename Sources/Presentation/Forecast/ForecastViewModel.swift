//
//  ForecastViewModel.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

final class ForecastViewModel: ObservableObject {
    // MARK: - State -

    @Published var state = ForecastState.initial

    // MARK: - Properties -

    private var currentWeatherForecast: CurrentWeatherForecastModel?
    private var hourlyForecastsState: Result<[HourlyWeatherForecastModel], NetworkError>?
    private unowned let coordinator: WeatherCoordinating
    private let city: String

    // MARK: - Dependencies -

    private let weatherUseCase: WeatherForecastUseCaseType

    // MARK: - Init -

    init(
        coordinator: WeatherCoordinating,
        city: String,
        weatherUseCase: WeatherForecastUseCaseType = WeatherForecastSDK.shared.assembler.resolveWeatherUseCase()
    ) {
        self.coordinator = coordinator
        self.city = city
        self.weatherUseCase = weatherUseCase
    }

    func load() {
        state = .loading
        fetchHourlyForecastAndUpdateState()
        fetchCurrentForecastAndUpdateState()
    }

    func close() {
        coordinator.close()
    }

    // MARK: - State -

    private func updateState(){
        guard let currentWeatherForecast else {
            state = .loading
            return
        }

        guard let hourlyForecastsState else {
            state = .loaded(forecast: makeCurrentForecastItem(currentForecastModel: currentWeatherForecast), hourlyForecastState: .loading)
            return
        }

        switch hourlyForecastsState {
        case let .success(forecasts):
            state = .loaded(
                forecast: makeCurrentForecastItem(currentForecastModel: currentWeatherForecast),
                hourlyForecastState: .loaded(items: makeHourlyForecastItems(hourlyForecastModels: forecasts))
            )
        case .failure:
            state = .loaded(
                forecast: makeCurrentForecastItem(currentForecastModel: currentWeatherForecast),
                hourlyForecastState: .error(
                    retry: { [unowned self] in
                        self.hourlyForecastsState = nil
                        updateState()
                        fetchCurrentForecastAndUpdateState()
                    }
                )
            )
        }
    }

    private func makeCurrentForecastItem(currentForecastModel: CurrentWeatherForecastModel) -> ForecastState.CurrentForecastItem {
        .init(
            mainInfoText: "The weather in \(currentForecastModel.cityName) is:",
            temperature: makeDegreeCelsius(from: currentForecastModel.temp),
            forecastDescription: currentForecastModel.description,
            timeUpdatedText: "AT \(makeTimeString(from: currentForecastModel.timestamp)) LOCAL TIME"
        )
    }

    private func makeHourlyForecastItems(hourlyForecastModels: [HourlyWeatherForecastModel]) -> [ForecastState.HourlyForecastItem] {
        hourlyForecastModels.map(makeHourlyForecastItem)
    }

    private func makeHourlyForecastItem(hourlyForecastModel: HourlyWeatherForecastModel) -> ForecastState.HourlyForecastItem {
        .init(
            id: hourlyForecastModel.timestamp,
            time: makeTimeString(from: hourlyForecastModel.timestamp),
            temp: makeDegreeCelsius(from: hourlyForecastModel.temp),
            description: hourlyForecastModel.description
        )
    }

    private func makeDegreeCelsius(from temp: Double) -> String {
        String(format: "%.0f°C", temp) //FIXME:  Do we skip decimals? If so, do we round up or down :/
    }

    private func makeTimeString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }

    // MARK: - Network -

    private func fetchCurrentForecastAndUpdateState() {
        Task { @MainActor  [weak self, weatherUseCase, city] in
            let response = await weatherUseCase.fetchCurrentWeatherForecast(city: city)
            switch response {
            case let .success(forecast):
                self?.currentWeatherForecast = forecast
                self?.updateState()
            case let .failure(error):
                self?.coordinator.didFailFetchingForecastingData(with: error)
            }
        }
    }

    private func fetchHourlyForecastAndUpdateState() {
        Task { @MainActor  [weak self, weatherUseCase, city] in
            let response = await weatherUseCase.fetchHourlyWeatherForecast(city: city)
            self?.hourlyForecastsState = response
            self?.updateState()
        }
    }
}
