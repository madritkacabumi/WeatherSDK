//
//  ForecastViewModelTests.swift
//  WeatherSDKTests
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import XCTest
import ConcurrencyExtras

@testable import WeatherSDK

final class ForecastViewModelTests: XCTestCase {
    var weatherCoordinator: WeatherCoordinatorMock!
    var weatherForecastUseCase: WeatherForecastUseCaseMock!
    let city = "Munich"
    var viewModel: ForecastViewModel!

    let hourlyWeatherForecastModels = [StubModel.makeHourlyWeatherForecastModel()]
    var timestamp: Date {
        var dateComponents = DateComponents()
        dateComponents.year = 2024
        dateComponents.month = 8
        dateComponents.day = 24
        dateComponents.hour = 10
        dateComponents.minute = 00
        return Calendar.current.date(from: dateComponents)!
    }

    override func setUp() {
        super.setUp()

        weatherCoordinator = .init()
        weatherForecastUseCase = .init()
    }

    override func invokeTest() {
        withMainSerialExecutor {
            super.invokeTest()
        }
    }

    func testCloseActionCallsCoordinatorCLoseFunction() {
        // given && when
        setupViewModel()
        viewModel.close()

        // then
        XCTAssertTrue(weatherCoordinator.invokedCloseCount == 1)
    }

    func testShowsLoadingLoadingStarts() {
        // given
        weatherForecastUseCase.fetchCurrentWeatherForecastResult = .success(StubModel.makeCurrentWeatherModel(cityName: city, timestamp: timestamp))
        weatherForecastUseCase.fetchHourlyWeatherForecastResult = .success(hourlyWeatherForecastModels)
        setupViewModel()

        // when
        viewModel.load()

        // then
        XCTAssertTrue(viewModel.state == .loading)
    }

    func testMakesCorrectItemsForHeader() async throws {
        // given
        let currentWeatherForecast = StubModel.makeCurrentWeatherModel(cityName: city, timestamp: timestamp)
        weatherForecastUseCase.fetchCurrentWeatherForecastResult = .success(currentWeatherForecast)
        weatherForecastUseCase.fetchHourlyWeatherForecastResult = .success(hourlyWeatherForecastModels)
        setupViewModel()

        // when
        viewModel.load()
        await Task.yield()

        // then
        XCTAssertEqual(viewModel.state.loadedCurrentWeatherForecast.mainInfoText, "The weather in \(city) is:")
        XCTAssertEqual(viewModel.state.loadedCurrentWeatherForecast.forecastDescription, currentWeatherForecast.description)
        XCTAssertEqual(viewModel.state.loadedCurrentWeatherForecast.timeUpdatedText, "AT 10:00 LOCAL TIME")
        XCTAssertEqual(viewModel.state.loadedCurrentWeatherForecast.temperature, String(format: "%.0f°C", currentWeatherForecast.temp))
    }

    func testMakesCorrectHourlyForecastItems() async throws {
        // given
        let currentWeatherForecast = StubModel.makeCurrentWeatherModel(cityName: city, timestamp: timestamp)
        weatherForecastUseCase.fetchCurrentWeatherForecastResult = .success(currentWeatherForecast)
        let hourlyStub1 = StubModel.makeHourlyWeatherForecastModel(temp: 20, timestamp: timestamp, description: "Sunny")
        weatherForecastUseCase.fetchHourlyWeatherForecastResult = .success([hourlyStub1])
        setupViewModel()

        // when
        viewModel.load()
        await Task.yield()

        // then
        XCTAssertEqual(viewModel.state.loadedHourlyWeatherForecast.count, 1)
        XCTAssertEqual(viewModel.state.loadedHourlyWeatherForecast.first!.temp, String(format: "%.0f°C", hourlyStub1.temp))
        XCTAssertEqual(viewModel.state.loadedHourlyWeatherForecast.first!.time, "10:00")
        XCTAssertEqual(viewModel.state.loadedHourlyWeatherForecast.first!.description, hourlyStub1.description)
    }

    // MARK: - Error -

    func testCallsCoordinatorWhenFetchingCurrentWeatherFails() async {
        // given
        weatherForecastUseCase.fetchCurrentWeatherForecastResult = .failure(.generic)

        let hourlyStub1 = StubModel.makeHourlyWeatherForecastModel(temp: 20, timestamp: timestamp, description: "Sunny")
        weatherForecastUseCase.fetchHourlyWeatherForecastResult = .success([hourlyStub1])
        setupViewModel()

        // when
        viewModel.load()
        await Task.yield()

        // then
        XCTAssertTrue(weatherCoordinator.invokedCountDidFailFetchingForecastingData == 1)
    }

    func testShowsErrorStateForHourlyForecast() async {
        // given
        weatherForecastUseCase.fetchCurrentWeatherForecastResult = .success(StubModel.makeCurrentWeatherModel())
        weatherForecastUseCase.fetchHourlyWeatherForecastResult = .failure(.generic)
        setupViewModel()

        // when
        viewModel.load()
        await Task.yield()

        // then
        guard case .error = viewModel.state.loadedHourlyWeatherState else {
            XCTFail("Invalid state")
            return
        }
    }
}

extension ForecastViewModelTests {
    func setupViewModel() {
        viewModel = .init(coordinator: weatherCoordinator, city: city, weatherUseCase: weatherForecastUseCase)
    }
}

extension ForecastState {
    var loadedCurrentWeatherForecast: CurrentForecastItem {
        guard case let .loaded(forecast, _) = self else {
            fatalError("Invalid state")
        }
        return forecast
    }

    var loadedHourlyWeatherState: HourlyForecastState {
        guard case let .loaded(_, hourlyForecastState) = self else {
            fatalError("Invalid state")
        }
        return hourlyForecastState
    }

    var loadedHourlyWeatherForecast: [HourlyForecastItem] {
        guard case let .loaded(items) = loadedHourlyWeatherState else {
            fatalError("Invalid state")
        }
        return items
    }
}
