//
//  WeatherForecastUseCaseMock.swift
//  WeatherSDKTests
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import Foundation
@testable import WeatherSDK

class WeatherForecastUseCaseMock: WeatherForecastUseCaseType {
    var invokedCountFetchCurrentWeatherForecast = Int.zero
    var fetchCurrentWeatherForecastResult: Result<CurrentWeatherForecastModel, NetworkError>!

    func fetchCurrentWeatherForecast(city: String) async -> Result<CurrentWeatherForecastModel, NetworkError> {
        invokedCountFetchCurrentWeatherForecast += 1
        return fetchCurrentWeatherForecastResult
    }

    var invokedCountFetchHourlyWeatherForecast = Int.zero
    var fetchHourlyWeatherForecastResult: Result<[HourlyWeatherForecastModel], NetworkError>!

    func fetchHourlyWeatherForecast(city: String) async -> Result<[HourlyWeatherForecastModel], NetworkError> {
        invokedCountFetchHourlyWeatherForecast += 1
        return fetchHourlyWeatherForecastResult
    }
}
