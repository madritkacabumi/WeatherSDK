//
//  WeatherSDK.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 22.08.24.
//

import SwiftUI
import UIKit

/// A delegate protocol to handle events in the WeatherForecastSDK.
public protocol WeatherForecastSDKDelegate: AnyObject {

    /// Called when the weather forecast operation finishes successfully.
    func onFinish()

    /// Called when the weather forecast operation finishes with an error.
    /// - Parameter error: The error that occurred during the operation.
    func onFinish(with error: WeatherForecastSDKError)
}

/// An enumeration of possible errors that can occur within the WeatherForecastSDK.
///
/// - sdkNotInitialised: The SDK was used before being initialized.
/// - invalidKey: The provided API key is invalid. Includes an associated message explaining why.
/// - networkFailure: A network request failed.
public enum WeatherForecastSDKError: Error, Equatable {
    case sdkNotInitialised
    case invalidKey(message: String)
    case networkFailure
}

/// The main class for interacting with the WeatherForecastSDK. This class is responsible for initializing the SDK and providing access to the weather forecast functionality.
public final class WeatherForecastSDK {
    // MARK: - Properties -

    /// The shared singleton instance of the WeatherForecastSDK.
    public static let shared = WeatherForecastSDK()

    /// The assembler responsible for assembling layers for the  sdk.
    let assembler: Assembler = WeatherSDKAssembler()

    /// A flag indicating whether the SDK has been initialized.
    private var isIntialised = false

    // MARK: - Initialization -

    /// Private initializer to enforce singleton usage.
    private init() {}

    // MARK: - Methods -

    /// Initializes the WeatherForecastSDK with the provided API key. This method must be called before attempting to use the SDK.
    ///
    /// - Parameter key: The API key required for authenticating API requests.
    public func initialiseSDK(with key: String) {
        assembler.setup(with: key)
        isIntialised = true
    }

    /// Creates and returns a `UIViewController` that displays the weather forecast for the specified city.
    ///
    /// - Parameters:
    ///   - delegate: The delegate that will handle SDK lifecycle events.
    ///   - city: The name of the city for which to display the weather forecast.
    /// - Returns: A `UIViewController` that displays the weather forecast.
    ///
    /// - Note: The SDK must be initialized using `initialiseSDK(with:)` before calling this method.
    public func makeWeatherForecastController(delegate: WeatherForecastSDKDelegate, city: String) -> UIViewController {
        return UIHostingController(
            rootView: WeatherCoordinatorView(
                coordinator: WeatherCoordinator(isSDKReady: isIntialised, delegate: delegate),
                city: city
            )
        )
    }
}
