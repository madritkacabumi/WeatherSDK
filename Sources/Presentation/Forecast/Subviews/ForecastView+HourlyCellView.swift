//
//  HourlyForecastCellView.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import SwiftUI

extension ForecastView {
    struct HourlyCellView: View {
        let item: ForecastState.HourlyForecastItem

        var body: some View {
            HStack(spacing: Theme.Dimens.xxSmall) {
                Text(item.time)
                    .font(Theme.Font.regular)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.temp)
                    .font(Theme.Font.title)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(item.description)
                    .font(Theme.Font.regular)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
        }
    }
}

struct ForecastViewHourlyCellView_Provider: PreviewProvider {
    static var previews: some View {
        ForecastView.HourlyCellView(
            item: .init(
                id: Date(),
                time: "10:00",
                temp: "27°C",
                description: "Sunny"
            )
        )
    }
}
