//
//  ForecastView+HeaderItem.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

extension ForecastView {
    struct HeaderView: View {
        let item: ForecastState.CurrentForecastItem

        var body: some View {
            VStack(spacing: Theme.Dimens.xxxxSmall) {
                Text(item.mainInfoText)
                    .font(Theme.Font.regular)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.temperature)
                    .font(Theme.Font.header1)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.forecastDescription)
                    .font(Theme.Font.regular)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.timeUpdatedText)
                    .font(Theme.Font.label)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }
}

struct ForecastViewHeaderView_Provider: PreviewProvider {
    static var previews: some View {
        ForecastView.HeaderView(
            item: .init(
                mainInfoText: "The weather in Munich is:",
                temperature: "27°C",
                forecastDescription: "Broken clouds",
                timeUpdatedText: "AT 17:14 LOCAL TIME"
            )
        )
    }
}
