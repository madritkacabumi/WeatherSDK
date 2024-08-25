//
//  WeatherCoordinatorView.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

struct WeatherCoordinatorView: View {
    @StateObject var coordinator: WeatherCoordinator
    private let city: String

    init(coordinator: WeatherCoordinator, city: String) {
        self._coordinator = .init(wrappedValue: coordinator)
        self.city = city
    }

    var body: some View {
        Group {
            if coordinator.isSDKReady {
                NavigationStack {
                    ForecastScene.makeScene(city: city, coordinator: coordinator)
                        .toolbarBackground(Theme.Colors.navigationBarBackground, for: .navigationBar)
                        .navigationBarBackButtonHidden(true)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
            } else {
                Text("SDK Not initialised")
                    .font(Theme.Font.title)
                    .foregroundStyle(Theme.Colors.textPlaceholder)
            }
        }
        .onAppear() {
            coordinator.start()
        }
    }
}
