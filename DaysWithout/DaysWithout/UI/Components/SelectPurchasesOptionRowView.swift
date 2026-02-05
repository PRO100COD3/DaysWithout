//
//  SelectPurchasesOptionRowView.swift
//  DaysWithout
//

import SwiftUI

/// Одна строка опции подписки (цена и период); выделение и действие по нажатию.
struct SelectPurchasesOptionRowView: View {
    let option: SubscriptionOption
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(option.priceText)
                    .font(.custom(Theme.headingFontName, size: Theme.selectPurchasesOptionPriceFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.selectPurchasesOptionSelectedTextColor : Theme.selectPurchasesOptionTextColor)
                Spacer()
                Text(option.periodTitle)
                    .font(.custom(Theme.headingFontName, size: Theme.selectPurchasesOptionPeriodFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Theme.selectPurchasesOptionSelectedSubtextColor : Theme.selectPurchasesOptionTextColor.opacity(Theme.selectPurchasesOptionUnselectedOpacity))
            }
            .padding(Theme.selectPurchasesOptionPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                Theme.selectPurchasesOptionSelectedGradientTop,
                                Theme.selectPurchasesOptionSelectedGradientBottom
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        Theme.selectPurchasesOptionUnselectedBackground
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.selectPurchasesOptionCornerRadius))
            .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.selectPurchasesOptionShadowRadius, x: 0, y: Theme.selectPurchasesOptionShadowY)
        }
        .buttonStyle(.plain)
        .pressAnimation()
    }
}
