//
//  WeatherCoordinatorTests.swift
//  WeatherSDKTests
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import Foundation
import XCTest

@testable import WeatherSDK

final class WeatherCoordinatorTests: XCTestCase {
    var delegate: WeatherForecastSDKDelegateImpl!
    var coordinator: WeatherCoordinator!

    override func setUp() {
        super.setUp()
        delegate = WeatherForecastSDKDelegateImpl()
    }

    func testInvokesOnFinishWhenCloseIsCalled() {
        // given
        coordinator = makeCoordinator()

        // when
        coordinator.close()

        // then
        XCTAssertEqual(delegate.invokedOnFinishCount, 1)
    }

    func testInvokesNotInitialisedError() {
        // given
        coordinator = makeCoordinator(isSdkReady: false)

        // when
        coordinator.start()

        // then
        XCTAssertEqual(delegate.onFinishWithErrorParameters.last!, .sdkNotInitialised)
    }

    func testInvokesOnFinishWithCorrectErrorWhenFailureOccursIsCalled() {
        // given
        coordinator = makeCoordinator()

        // when && then
        coordinator.didFailFetchingForecastingData(with: .decodingFailed)
        XCTAssertEqual(delegate.onFinishWithErrorParameters.last!, .networkFailure)

        coordinator.didFailFetchingForecastingData(with: .generic)
        XCTAssertEqual(delegate.onFinishWithErrorParameters.last!, .networkFailure)

        coordinator.didFailFetchingForecastingData(with: .invalidResponse)
        XCTAssertEqual(delegate.onFinishWithErrorParameters.last!, .networkFailure)

        coordinator.didFailFetchingForecastingData(with: .invalidKey("Hey"))
        XCTAssertEqual(delegate.onFinishWithErrorParameters.last!, .invalidKey(message: "Hey"))

        XCTAssertTrue(delegate.invokedOnFinishWithErrorCount > .zero)
    }
}

extension WeatherCoordinatorTests {
    func makeCoordinator(isSdkReady: Bool = true) -> WeatherCoordinator {
        .init(isSDKReady: isSdkReady, delegate: delegate)
    }
}

extension WeatherCoordinatorTests {
    final class WeatherForecastSDKDelegateImpl: WeatherForecastSDKDelegate {
        var invokedOnFinishCount = Int.zero
        func onFinish() {
            invokedOnFinishCount += 1
        }
        
        var invokedOnFinishWithErrorCount = Int.zero
        var onFinishWithErrorParameters: [WeatherForecastSDKError] = []
        func onFinish(with error: WeatherForecastSDKError) {
            invokedOnFinishWithErrorCount += 1
            onFinishWithErrorParameters.append(error)
        }
    }
}
