//
//  WeatherCoordinator.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

protocol WeatherCoordinating: AnyObject {
    func didFailFetchingForecastingData(with error: NetworkError)
    func close()
}

final class WeatherCoordinator: ObservableObject, WeatherCoordinating {

    weak var delegate: WeatherForecastSDKDelegate?
    let isSDKReady: Bool
    
    init(isSDKReady: Bool, delegate: WeatherForecastSDKDelegate?) {
        self.isSDKReady = isSDKReady
        self.delegate = delegate
    }

    func start() {
        if !isSDKReady {
            delegate?.onFinish(with: .sdkNotInitialised)
        }
    }

    func didFailFetchingForecastingData(with error: NetworkError) {
        delegate?.onFinish(with: mapError(networkError: error))
    }

    private func mapError(networkError: NetworkError) -> WeatherForecastSDKError {
        switch networkError {
        case .generic, .invalidResponse, .decodingFailed:
            return .networkFailure
        case let .invalidKey(message):
            return .invalidKey(message: message)
        }
    }

    func close() {
        delegate?.onFinish()
    }
}
