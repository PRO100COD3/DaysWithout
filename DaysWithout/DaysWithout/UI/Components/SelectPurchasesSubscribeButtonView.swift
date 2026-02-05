//
//  SelectPurchasesSubscribeButtonView.swift
//  DaysWithout
//

import SwiftUI

/// Кнопка «Оформить подписку» на экране выбора подписки.
struct SelectPurchasesSubscribeButtonView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom(Theme.headingFontName, size: Theme.selectPurchasesSubscribeButtonFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.addHabitCreateButtonTextColor)
                .frame(maxWidth: .infinity)
                .frame(height: Theme.addHabitButtonHeight)
                .background(Theme.addHabitCreateButtonBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: Theme.selectPurchasesSubscribeButtonStrokeCornerRadius)
                        .stroke(Theme.addHabitCreateButtonBorderColor, lineWidth: Theme.selectPurchasesStrokeLineWidth)
                }
                .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.selectPurchasesSubscribeButtonShadowRadius, x: 0, y: Theme.selectPurchasesSubscribeButtonShadowY)
        }
        .pressAnimation()
    }
}
