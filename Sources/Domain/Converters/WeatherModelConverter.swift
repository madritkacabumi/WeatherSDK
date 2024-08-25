//
//  WeatherModelConverter.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

enum WeatherModelConverter {
    static func from(response: CurrentWeatherForecastResponse) -> CurrentWeatherForecastModel? {
        guard let data = response.data.first else {
            return nil
        }
        return .init(
            cityName: data.cityName,
            temp: data.temp,
            description: data.weather.description,
            timestamp: Date(timeIntervalSince1970: Double(data.ts))
        )
    }

    static func from(response: HourlyWeatherForecastResponse) -> [HourlyWeatherForecastModel] {
        response.data.map(from(weatherData:))
    }

    private static func from(weatherData: HourlyWeatherForecastResponse.WeatherData) -> HourlyWeatherForecastModel {
        .init(temp: weatherData.temp, timestamp: parseTimestampLocal(weatherData.timestampLocal)!, description: weatherData.weather.description)
    }

    private static func parseTimestampLocal(_ timestamp: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.date(from: timestamp)
    }
}
