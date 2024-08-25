//
//  ViewController.swift
//  WeatherExampleApp
//
//  Created by Madrit Kacabumi on 22.08.24.
//

import UIKit
import WeatherSDK

class ViewController: UIViewController {
    private enum Constants {
        static let componentHeight = CGFloat(AppTheme.Dimens.xLarge + AppTheme.Dimens.xxSmall)
    }
    // MARK: - Views -

    private lazy var inputLabel: UILabel = {
        let label = UILabel()
        label.font = AppTheme.Font.header2
        label.numberOfLines = .zero
        label.textColor = AppTheme.Colors.textPrimary
        label.text = "Enter a city name for the weather forecast"
        return label
    }()

    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = AppTheme.Colors.textBorder.cgColor
        textField.layer.borderWidth = AppTheme.Dimens.one
        textField.layer.cornerRadius = AppTheme.Dimens.xxSmall
        textField.layer.masksToBounds = true
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppTheme.Colors.textPlaceholder,
            .font: AppTheme.Font.regular
        ]
        textField.attributedPlaceholder = NSAttributedString(string: "Search city", attributes: placeholderAttributes)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: Constants.componentHeight).isActive = true
        let paddingView = UIView(frame: CGRect(x: .zero, y: .zero, width: AppTheme.Dimens.xSmall, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.delegate = self
        textField.returnKeyType = .search
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton(
            type: .custom,
            primaryAction: .init { [unowned self] _ in
                openWeatherSDK()
            }
        )
        button.setTitle("Weather Forecast", for: .normal)
        button.titleLabel?.font = AppTheme.Font.title
        button.backgroundColor = AppTheme.Colors.accent
        button.setBackgroundColor(color: AppTheme.Colors.accent, forState: .normal)
        button.setBackgroundColor(color: AppTheme.Colors.accentHighlighted, forState: .highlighted)
        button.layer.cornerRadius = AppTheme.Dimens.small
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant:  Constants.componentHeight).isActive = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        self.navigationItem.title = "Example App"
        self.view.backgroundColor = .white
        // Add tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppTheme.Dimens.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppTheme.Dimens.large),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: AppTheme.Dimens.medium),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -AppTheme.Dimens.medium),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppTheme.Dimens.medium)
        ])

        stackView.addArrangedSubview(inputLabel)
        stackView.addArrangedSubview(inputTextField)
        stackView.addArrangedSubview(button)
    }

    private func openWeatherSDK() {
        guard let citySearchTerm = inputTextField.text, !citySearchTerm.isEmpty else {
            inputTextField.layer.borderColor = UIColor.red.cgColor
            return
        }

        let weatherController = WeatherForecastSDK.shared.makeWeatherForecastController(delegate: self, city: citySearchTerm)
        weatherController.modalPresentationStyle = .fullScreen
        present(weatherController, animated: true)
    }
}

// MARK: - WeatherForecastSDKDelegate -

extension ViewController: WeatherForecastSDKDelegate {
    func onFinish() {
        presentedViewController?.dismiss(animated: true)
    }
    
    func onFinish(with error: WeatherForecastSDKError) {
        let alert = UIAlertController(title: "Failure", message: makeMessage(from: error), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default) { [unowned self] _ in
            presentedViewController?.dismiss(animated: true)
        }
        alert.addAction(okAction)
        presentedViewController?.present(alert, animated: true, completion: nil)
    }

    private func makeMessage(from error: WeatherForecastSDKError) -> String {
        switch error {
        case .sdkNotInitialised:
            return "SDK Not initialised."
        case let .invalidKey(message):
            return message
        case .networkFailure:
            return "Ops.. Something went wrong"
        @unknown default:
            fatalError("Unknown error case")
        }
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.Colors.accentHighlighted.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.Colors.textBorder.cgColor
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        openWeatherSDK()
        return true
    }
}

extension ViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
