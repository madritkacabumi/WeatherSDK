//
//  BackButtonView.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 24.08.24.
//

import SwiftUI

struct BackButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(
            action: action,
            label: {
                HStack(spacing: Theme.Dimens.xxxxSmall) {
                    Image(systemName: "chevron.left")
                        .tint(Theme.Colors.accent)

                    Text("Back")
                        .font(Theme.Font.regular)
                        .tint(Theme.Colors.accent)
                }
            }
        )
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView {}
    }
}
