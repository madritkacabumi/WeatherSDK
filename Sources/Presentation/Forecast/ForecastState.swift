//
//  ForecastState.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

enum ForecastState: Equatable {
    case initial
    case loading
    case loaded(forecast: CurrentForecastItem, hourlyForecastState: HourlyForecastState)
}

extension ForecastState {
    struct CurrentForecastItem: Equatable {
        let mainInfoText: String
        let temperature: String
        let forecastDescription: String
        let timeUpdatedText: String
    }

    enum HourlyForecastState {
        case loading
        case error(retry: () -> Void)
        case loaded(items: [HourlyForecastItem])
    }

    struct HourlyForecastItem: Equatable, Identifiable {
        let id: Date
        let time: String
        let temp: String
        let description: String
    }
}

extension ForecastState.HourlyForecastState: Equatable {
    static func == (lhs: ForecastState.HourlyForecastState, rhs: ForecastState.HourlyForecastState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
            
        case (.error, .error):
            return true
            
        case (.loaded(let lhsItems), .loaded(let rhsItems)):
            return lhsItems == rhsItems
            
        default:
            return false
        }
    }
}
