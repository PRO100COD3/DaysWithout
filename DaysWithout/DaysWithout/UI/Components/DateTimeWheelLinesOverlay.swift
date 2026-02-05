//
//  DateTimeWheelLinesOverlay.swift
//  DaysWithout
//

import SwiftUI

/// Две горизонтальные линии по краям выбранной строки в пикере времени.
struct DateTimeWheelLinesOverlay: View {
    private let rowHeight = Theme.dateTimeWheelRowHeight
    private let totalHeight = Theme.dateTimeWheelVisibleHeight + Theme.dateTimeWheelTopPadding
    private var topInset: CGFloat { (totalHeight - rowHeight) / 2 }
    private var lineColor: Color { Color.black.opacity(Theme.dateTimeWheelLineOpacity) }

    var body: some View {
        VStack(spacing: Theme.dateContentStackSpacing) {
            Spacer()
                .frame(height: topInset)
            Rectangle()
                .fill(lineColor)
                .frame(height: Theme.dateTimeWheelLineHeight)
            Spacer()
                .frame(height: rowHeight)
            Rectangle()
                .fill(lineColor)
                .frame(height: Theme.dateTimeWheelLineHeight)
            Spacer()
        }
        .allowsHitTesting(false)
    }
}
