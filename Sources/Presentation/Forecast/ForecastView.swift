//
//  ForecastView.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

struct ForecastView: View {
    let currentWeatherForecastItem: ForecastState.CurrentForecastItem
    let hourlyForecastsState: ForecastState.HourlyForecastState

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: .zero) {
                HeaderView(item: currentWeatherForecastItem)
                    .animation(nil, value: hourlyForecastsState)
                makeHourlyForecastViewDependingOnState()
                    .padding(.vertical, Theme.Dimens.medium)
            }
            .animation(.default, value: hourlyForecastsState)
            .padding(.vertical, Theme.Dimens.medium)
        }
    }

    @ViewBuilder
    private func makeHourlyForecastViewDependingOnState() -> some View {
        switch hourlyForecastsState {
        case .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Theme.Colors.accent)
                .frame(alignment: .center)
        case let .error(retryAction):
            ErrorView(action: retryAction)
        case let .loaded(items):
            makeHourlyForecastItems(items)
        }
    }

    private func makeHourlyForecastItems(_ items: [ForecastState.HourlyForecastItem]) -> some View {
        LazyVStack(spacing: .zero) {
            ForEach(items) { item in
                makeSingleCellView(item: item)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func makeSingleCellView(item: ForecastState.HourlyForecastItem) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            HourlyCellView(item: item)
                .padding(.horizontal, Theme.Dimens.medium)
                .padding(.vertical, Theme.Dimens.small)
            Rectangle()
                .fill(Theme.Colors.textBorder)
                .frame(height: Theme.Dimens.one)
        }
    }
}

struct ForecastView_Provider: PreviewProvider {
    private static let currentWeatherForecastItem = ForecastState.CurrentForecastItem(
        mainInfoText: "The weather in Munich is:",
        temperature: "27°C",
        forecastDescription: "Broken clouds",
        timeUpdatedText: "AT 17:14 LOCAL TIME"
    )

    private static let hourlyForecastItems: [ForecastState.HourlyForecastItem] = [
        .init(id: Date(), time: "10:00", temp: "27°C", description: "Sunny"),
        .init(id: Date(), time: "11:00", temp: "29°C", description: "Clear"),
        .init(id: Date(), time: "12:00", temp: "33°C", description: "Clear"),
        .init(id: Date(), time: "13:00", temp: "33°C", description: "Sunny"),
        .init(id: Date(), time: "14:00", temp: "30°C", description: "Slightly cloudy"),
    ]

    static var previews: some View {
        ForecastView(
            currentWeatherForecastItem: currentWeatherForecastItem,
            hourlyForecastsState: .loading
        )
        .previewDisplayName("Loading Hourly Forecast")

        ForecastView(
            currentWeatherForecastItem: currentWeatherForecastItem,
            hourlyForecastsState: .loaded(items: hourlyForecastItems)
        )
        .previewDisplayName("Loaded Hourly Forecast")

        ForecastView(
            currentWeatherForecastItem: currentWeatherForecastItem,
            hourlyForecastsState: .error(retry: {})
        )
        .previewDisplayName("Error Hourly Forecast")
    }
}
