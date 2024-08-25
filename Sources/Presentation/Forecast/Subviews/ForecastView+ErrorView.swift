//
//  ForecastView+ErrorView.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

extension ForecastView {
    struct ErrorView: View {
        let action: () -> Void

        var body: some View {
            VStack(spacing: Theme.Dimens.xxSmall) {
                Text("Something went wrong while fetching hourly forecast. Please try again!")
                    .font(Theme.Font.regular)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)

                Button(action: action, label: {
                    Text("Retry")
                        .font(Theme.Font.title)
                        .foregroundStyle(.white)
                        .padding(Theme.Dimens.xxSmall)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Dimens.xxSmall, style: .continuous)
                            .fill(Theme.Colors.accent)
                        )
                })
            }
            .padding(.horizontal, Theme.Dimens.medium)
        }
    }
}

