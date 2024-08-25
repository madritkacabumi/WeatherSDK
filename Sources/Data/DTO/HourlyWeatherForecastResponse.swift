//
//  HourlyWeatherForecastResponse.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

struct HourlyWeatherForecastResponse: Codable {
    let cityName: String
    let countryCode: String
    let data: [WeatherData]
    let lat: String
    let lon: String
    let stateCode: String
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case cityName = "city_name"
        case countryCode = "country_code"
        case data
        case lat
        case lon
        case stateCode = "state_code"
        case timezone
    }
}

// MARK: - WeatherDetails -

extension HourlyWeatherForecastResponse {
    struct WeatherDetails: Codable {
        let description: String
    }
}

// MARK: - WeatherData -

extension HourlyWeatherForecastResponse {
    struct WeatherData: Codable {
        let temp: Double
        let timestampLocal: String
        let weather: WeatherDetails

        enum CodingKeys: String, CodingKey {
            case temp
            case timestampLocal = "timestamp_local"
            case weather
        }
    }
}
