//
//  MainEmptyStateView.swift
//  DaysWithout
//

import SwiftUI

/// Пустое состояние главного экрана: заголовок и подзаголовок.
struct MainEmptyStateView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: Theme.emptyStateSpacing) {
            Text(title)
                .font(.custom(Theme.headingFontName, size: Theme.emptyStateHeadingFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainHeadingColor)

            Text(subtitle)
                .font(.custom(Theme.headingFontName, size: Theme.emptyStateDescriptionFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainDescriptionColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.emptyStateTopPadding)
    }
}
