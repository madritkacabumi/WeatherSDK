//
//  WeatherForecastUseCaseType.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

protocol WeatherForecastUseCaseType {
    func fetchCurrentWeatherForecast(city: String) async -> Result<CurrentWeatherForecastModel, NetworkError>
    func fetchHourlyWeatherForecast(city: String) async -> Result<[HourlyWeatherForecastModel], NetworkError>
}

struct WeatherForecastUseCase: WeatherForecastUseCaseType {
    let networkService: NetworkServiceType
    let apiConfig: APIConfig

    func fetchCurrentWeatherForecast(city: String) async -> Result<CurrentWeatherForecastModel, NetworkError> {
        let resource = CurrentWeatherForecastResource(city: city, apiConfig: apiConfig)
        do {
            let weatherResponse = try await networkService.request(resource: resource, for: CurrentWeatherForecastResponse.self)
            if let weatherModel = WeatherModelConverter.from(response: weatherResponse) {
                return .success(weatherModel)
            } else {
                return .failure(.invalidResponse)
            }
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.generic)
        }
    }

    func fetchHourlyWeatherForecast(city: String) async -> Result<[HourlyWeatherForecastModel], NetworkError> {
        let resource = HourlyWeatherForecastResource(city: city, apiConfig: apiConfig)
        do {
            let hourlyWeatherForecastResponse = try await networkService.request(resource: resource, for: HourlyWeatherForecastResponse.self)
            return .success(WeatherModelConverter.from(response: hourlyWeatherForecastResponse))
        } catch let error as NetworkError {
            return .failure(error)
        } catch {
            return .failure(.generic)
        }
    }
}
