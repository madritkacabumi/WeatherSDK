//
//  ForecastScene.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

struct ForecastScene: View {
    @StateObject var viewModel: ForecastViewModel

    init(viewModel: ForecastViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        makeContent()
            .navigationTitle("24H Forecast")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButtonView(action: viewModel.close)
                }
            }
            .onAppear() {
                viewModel.load()
            }
    }

    @ViewBuilder
    private func makeContent() -> some View {
        switch viewModel.state {
        case .initial, .loading:
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Theme.Colors.accent)
        case let .loaded(forecast, hourlyForecastState):
            ForecastView(currentWeatherForecastItem: forecast, hourlyForecastsState: hourlyForecastState)
        }
    }
}

extension ForecastScene {
    static func makeScene(city: String, coordinator: WeatherCoordinating) -> ForecastScene {
        ForecastScene(viewModel: .init(coordinator: coordinator, city: city))
    }
}
