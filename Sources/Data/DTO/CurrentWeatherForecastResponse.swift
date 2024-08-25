//
//  CurrentWeatherForecastResponse.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

struct CurrentWeatherForecastResponse: Codable {
    let count: Int
    let data: [WeatherData]
}

// MARK: - Weather Data -

extension CurrentWeatherForecastResponse {
    struct WeatherData: Codable {
        let cityName: String
        let temp: Double
        let weather: Weather
        let ts: Int
        enum CodingKeys: String, CodingKey {
            case cityName = "city_name"
            case temp
            case weather
            case ts
        }
    }
}

// MARK: - Weather -

extension CurrentWeatherForecastResponse {
    struct Weather: Codable {
        let description: String
    }
}
