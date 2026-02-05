//
//  DateCreateButtonView.swift
//  DaysWithout
//

import SwiftUI

/// Кнопка «СОЗДАТЬ» на экране выбора даты/времени.
struct DateCreateButtonView: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("СОЗДАТЬ")
                .font(.custom(Theme.headingFontName, size: Theme.dateCreateButtonFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.dateCreateButtonTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.dateCreateButtonVerticalPadding)
                .background(Theme.dateCreateButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Theme.dateCreateButtonCornerRadius))
        }
        .padding(.top, Theme.dateCreateButtonTopPadding)
        .padding(.bottom, Theme.dateCreateButtonBottomPadding)
        .pressAnimation()
    }
}
