//
//  StoryHistoryCellView.swift
//  DaysWithout
//

import SwiftUI

/// Ячейка записи истории рестарта: дни, причина, диапазон дат.
struct StoryHistoryCellView: View {
    let daysText: String
    let reason: String?
    let dateRangeText: String

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.storyHistoryCellInternalSpacing) {
            Text(daysText)
                .font(.custom(Theme.headingFontName, size: Theme.storyHistoryCellDaysFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.storyHistoryCellGreen)
            if let reason = reason, !reason.isEmpty {
                Text(reason)
                    .font(.custom(Theme.headingFontName, size: Theme.storyHistoryCellReasonFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.storyHistoryCellReasonColor)
            }
            Text(dateRangeText)
                .font(.custom(Theme.headingFontName, size: Theme.storyHistoryCellDateFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.storyHistoryCellDateColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, Theme.storyHistoryCellHorizontalPadding)
        .padding(.vertical, Theme.storyHistoryCellVerticalPadding)
        .background(Color.white.opacity(Theme.storyHistoryCellBackgroundOpacity))
        .overlay(RoundedRectangle(cornerRadius: Theme.storyHistoryCellCornerRadius)
            .stroke(
                Color.black.opacity(Theme.storyHistoryCellStrokeOpacity),
                lineWidth: Theme.storyHistoryCellStrokeLineWidth
            ))
        .clipShape(RoundedRectangle(cornerRadius: Theme.storyHistoryCellCornerRadius))
        .shadow(color: Color.black.opacity(Theme.storyHistoryCellShadowOpacity), radius: Theme.storyHistoryCellShadowRadius, x: 0, y: Theme.storyHistoryCellShadowY)
    }
}
