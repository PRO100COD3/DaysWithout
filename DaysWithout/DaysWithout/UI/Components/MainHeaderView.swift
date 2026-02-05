//
//  MainHeaderView.swift
//  DaysWithout
//

import SwiftUI

/// Заголовок главного экрана: название и разделитель.
struct MainHeaderView: View {
    let title: String

    init(title: String = "Привычки") {
        self.title = title
    }

    var body: some View {
        VStack(spacing: Theme.mainContentStackSpacing) {
            Text(title)
                .font(.custom(Theme.headingFontName, size: Theme.mainHeadingFontSize))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, Theme.headerTopPadding)
                .padding(.bottom, Theme.headerBottomPadding)

            Divider()
                .background(Theme.DeviderColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, Theme.dividerBottomPadding)
        }
    }
}
