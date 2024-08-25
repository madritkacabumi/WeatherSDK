//
//  Assembler.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

protocol Assembler {

    func setup(with key: String)

    // MARK: - Network -

    func resolveNetworkService() -> NetworkServiceType

    // MARK: - UseCases -

    func resolveWeatherUseCase() -> WeatherForecastUseCaseType
}

protocol WeatherForecastSDKContainer: AnyObject {
    var networkService: NetworkServiceType { get }
}

final class WeatherSDKAssembler: Assembler {
    private enum Constants {
        static let baseApi = "https://api.weatherbit.io/v2.0"
    }
    // MARK: - Dependencies -

    let networkService: NetworkServiceType = NetworkService()
    var apiConfig: APIConfig!

    func setup(with key: String) {
        apiConfig = .init(baseAPI: Constants.baseApi, key: key)
    }

    func resolveNetworkService() -> any NetworkServiceType {
        networkService
    }

    // MARK: - UseCases -

    func resolveWeatherUseCase() -> any WeatherForecastUseCaseType {
        WeatherForecastUseCase(networkService: networkService, apiConfig: apiConfig)
    }
}
