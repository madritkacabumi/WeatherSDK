# WeatherForecastSDK Integration Guide

Welcome to the WeatherForecastSDK! This guide will help you integrate the SDK into your iOS project, initialize it, and display a weather forecast for a specific city.

## Table of Contents

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [Setup](#setup)
4. [Usage](#usage)
5. [Error Handling](#error-handling)
6. [Delegate Methods](#delegate-methods)
7. [Example](#example)
8. [Improvements](#improvements)

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Swift 5.5+

## Installation

You can integrate `WeatherForecastSDK` into your project using Swift Package Manager (SPM) or by manually adding the SDK files to your project.

### Using Swift Package Manager

1. Open your project in Xcode.
2. Go to `File > Add Packages`.
3. Enter the repository URL of the WeatherForecastSDK and select your target.
4. Choose the appropriate version, then click `Add Package`.

### Manual Installation

1. Download the `WeatherForecastSDK` source files.
2. Drag the files into your Xcode project.

## Setup

Before you can use the SDK, you must initialize it with your API key.

```swift
import WeatherForecastSDK

// Initialize the SDK with your API key
WeatherForecastSDK.shared.initialiseSDK(with: "YOUR_API_KEY")
```
## Usage

To display the weather forecast for a specific city, use the following method:

```swift
import UIKit
import WeatherForecastSDK

class YourViewController: UIViewController, WeatherForecastSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the weather forecast view controller
        let weatherVC = WeatherForecastSDK.shared.makeWeatherForecastController(delegate: self, city: "New York")

        // Present the weather view controller
        self.present(weatherVC, animated: true, completion: nil)
    }

    // MARK: - WeatherForecastSDKDelegate Methods

    func onFinish() {
        // Handle completion and make sure to dismiss the weather forecast controller
        self.presentedViewController?.dismiss(animated: true)
    }

    func onFinish(with error: WeatherForecastSDKError) {
        // Handle error
        print("Weather Forecast SDK Error: \(error)")
        // Make sure to dismiss the weather forecast controller
        self.presentedViewController?.dismiss(animated: true)
    }
}
```

## Error Handling

The SDK provides the `WeatherForecastSDKError` enum to handle various errors that may occur. Here are the possible errors:

- **sdkNotInitialised**: The SDK was used before being initialized. Make sure to call `initialiseSDK(with:)` first.
- **invalidKey**: The API key provided is invalid. Check your API key and try again.
- **networkFailure**: A network request failed. This could be due to a lack of internet connectivity or server issues.

Handle errors in the `onFinish(with:)` delegate method.

```swift
func onFinish(with error: WeatherForecastSDKError) {
    switch error {
    case .sdkNotInitialised:
        print("SDK not initialized. Please initialize the SDK before use.")
    case .invalidKey(let message):
        print("Invalid API key: \(message)")
    case .networkFailure:
        print("Network request failed. Please check your internet connection.")
    }
}
```
## Delegate Methods

Implement the `WeatherForecastSDKDelegate` protocol in your view controller to handle events like the successful completion of a weather forecast or any errors.

### Delegate Methods Overview

- **onFinish()**: Called when the weather forecast operation finishes successfully.
- **onFinish(with error: WeatherForecastSDKError)**: Called when the weather forecast operation finishes with an error.

### Example Implementation

```swift
import WeatherForecastSDK

class WeatherViewController: UIViewController, WeatherForecastSDKDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the SDK in viewdidLoad or whenever is needed, Just do it before creating the weather forecast controller
        WeatherForecastSDK.shared.initialiseSDK(with: "YOUR_API_KEY")

        // Create the weather forecast view controller
        let weatherVC = WeatherForecastSDK.shared.makeWeatherForecastController(delegate: self, city: "London")

        // Present the weather view controller
        self.present(weatherVC, animated: true, completion: nil)
    }

    // MARK: - WeatherForecastSDKDelegate

    func onFinish() {
        // Handle completion
        print("Weather forecast operation completed successfully.")
    }

    func onFinish(with error: WeatherForecastSDKError) {
        // Handle error
        switch error {
        case .sdkNotInitialised:
            print("SDK not initialized. Please initialize the SDK before use.")
        case .invalidKey(let message):
            print("Invalid API key: \(message)")
        case .networkFailure:
            print("Network request failed. Please check your internet connection.")
        }
    }
}

```
## Notes

- **Possible improvement with navigation controller:** Make weather controller integrateable in a navigation controller instead of only the `present` option:

- I noticed that on figma the font was `Satoshi` but I didn't integrate that in the SDK nor the example app.
- I also kept the example app simple with a plain `ViewController` for almost everything, while focused mostly in the SDK.
- Left out of testing the UseCases and the network layer in the SDK

