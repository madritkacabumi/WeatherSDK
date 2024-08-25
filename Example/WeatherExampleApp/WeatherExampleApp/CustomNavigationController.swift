//
//  CustomNavigationController.swift
//  WeatherExampleApp
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
    }
    
    private func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppTheme.Colors.navigationBarBackground
        appearance.titleTextAttributes =  [.foregroundColor: AppTheme.Colors.textPrimary]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
