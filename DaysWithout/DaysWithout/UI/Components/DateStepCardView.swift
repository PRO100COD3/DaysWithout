//
//  DateStepCardView.swift
//  DaysWithout
//

import SwiftUI

/// Обёртка контента шага (календарь или время) в карточку с фоном, обводкой и тенью.
struct DateStepCardView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.top, Theme.dateCalendarCardTopPadding)
            .padding(.horizontal, Theme.dateCalendarCardHorizontalPadding)
            .background(Color.white.opacity(Theme.dateCalendarCardBackgroundOpacity))
            .overlay(RoundedRectangle(cornerRadius: Theme.dateCalendarCardCornerRadius)
                .stroke(
                    Color.black.opacity(Theme.dateCalendarCardStrokeOpacity),
                    lineWidth: Theme.dateCalendarCardStrokeLineWidth
                ))
            .clipShape(RoundedRectangle(cornerRadius: Theme.dateCalendarCardCornerRadius))
            .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.dateCalendarCardShadowRadius, x: 0, y: Theme.dateCalendarCardShadowY)
    }
}
