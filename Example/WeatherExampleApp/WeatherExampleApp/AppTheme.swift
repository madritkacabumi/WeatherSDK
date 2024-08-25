//
//  AppTheme.swift
//  WeatherExampleApp
//
//  Created by Madrit Kacabumi on 22.08.24.
//

import UIKit

enum AppTheme {
    enum Colors {
        static let accent = UIColor(named: "Accent")!
        static let accentHighlighted = UIColor(named: "AccentHighlighted")!
        static let textPrimary = UIColor(named: "TextPrimary")!
        static let textSecondary = UIColor(named: "TextSecondary")!
        static let textPlaceholder = UIColor(named: "TextPlaceholder")!
        static let textBorder = UIColor(named: "TextBorder")!
        static let navigationBarBackground = UIColor(named: "NavigationBarBackground")!
    }

    enum Font {
        static let header1 = UIFont.systemFont(ofSize: 28, weight: .bold)
        static let header2 = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let title = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let regular = UIFont.systemFont(ofSize: 16, weight: .medium)
        static let label = UIFont.systemFont(ofSize: 12, weight: .medium)
    }

    enum Dimens {
        /// 1 point
        static let one: CGFloat = 1

        /// 128 points
        static let xxxxLarge: CGFloat = 128

        /// 72 points
        static let xxxLarge: CGFloat = 72

        /// 64 points
        static let xxLarge: CGFloat = 64

        /// 48 points
        static let xLarge: CGFloat = 48

        /// 32 points
        static let large: CGFloat = 32

        /// 24 points
        static let medium: CGFloat = 24

        /// 16 points
        static let small: CGFloat = 16

        /// 12 points
        static let xSmall: CGFloat = 12

        /// 8 points
        static let xxSmall: CGFloat = 8

        /// 4 points
        static let xxxSmall: CGFloat = 4

        /// 2 points
        static let xxxxSmall: CGFloat = 2
    }
}
