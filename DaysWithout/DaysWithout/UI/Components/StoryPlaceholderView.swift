//
//  StoryPlaceholderView.swift
//  DaysWithout
//

import SwiftUI

/// Заглушка экрана истории при отсутствии записей о рестартах.
struct StoryPlaceholderView: View {
    var body: some View {
        VStack(spacing: Theme.storyContentStackSpacing) {
            Text("После нажатия рестарта у вас отобразится история")
                .font(.custom(Theme.headingFontName, size: Theme.storyPlaceholderFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainHeadingColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.screenPadding * 2)
            Spacer()
        }
        .padding(.top, Theme.storyPlaceholderTopPadding)
    }
}
