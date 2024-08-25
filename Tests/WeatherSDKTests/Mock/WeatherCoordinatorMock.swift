//
//  WeatherCoordinatorMock.swift
//  WeatherSDKTests
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import Foundation
@testable import WeatherSDK

class WeatherCoordinatorMock: WeatherCoordinating {
    var invokedCloseCount = Int.zero
    
    func close() {
        invokedCloseCount += 1
    }
    
    var invokedCountDidFailFetchingForecastingData = Int.zero

    func didFailFetchingForecastingData(with error: NetworkError) {
        invokedCountDidFailFetchingForecastingData += 1
    }
}
