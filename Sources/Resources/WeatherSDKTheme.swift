//
//  WeatherSDKTheme.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

struct Theme {
    enum Colors {
        static let accent = Color("Accent")
        static let accentHighlighted = Color("AccentHighlighted")
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
        static let textPlaceholder = Color("TextPlaceholder")
        static let textBorder = Color("TextBorder")
        static let navigationBarBackground = Color("NavigationBarBackground")
    }

    enum Font {
        static let header1 = makeFont(size: 28, weight: .bold)
        static let header2 = makeFont(size: 20, weight: .bold)
        static let title = makeFont(size: 16, weight: .bold)
        static let regular = makeFont(size: 16, weight: .medium)
        static let label = makeFont(size: 12, weight: .medium)

        private static func makeFont(size: CGFloat, weight: SwiftUI.Font.Weight) -> SwiftUI.Font {
            SwiftUI.Font.system(size: size, weight: weight)
        }
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
