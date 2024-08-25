//
//  Stub.swift
//  WeatherSDKTests
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import Foundation

@testable import WeatherSDK

enum StubModel {
    static func makeCurrentWeatherModel(
        cityName: String = "Munich",
        temp: Double = 15,
        description: String = "Sunny",
        timestamp: Date = Date()
    ) -> CurrentWeatherForecastModel {
        .init(
            cityName: cityName,
            temp: temp,
            description: description,
            timestamp: timestamp
        )
    }

    static func makeHourlyWeatherForecastModel(
        temp: Double = 15,
        timestamp: Date = Date(),
        description: String = "Sunny"
    ) -> HourlyWeatherForecastModel {
        .init(
            temp: temp,
            timestamp: timestamp,
            description: description
        )
    }
}
