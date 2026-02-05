//
//  AddHabitColorCircleView.swift
//  DaysWithout
//

import SwiftUI

/// Кружок выбора цвета карточки в модалке добавления привычки.
struct AddHabitColorCircleView: View {
    let colorID: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        let colors = Theme.cardColor(for: colorID)
        return Button(action: action) {
            ZStack {
                LinearGradient(
                    colors: [colors.top, colors.bottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: Theme.addHabitColorCircleSize, height: Theme.addHabitColorCircleSize)
                .clipShape(Circle())
                if isSelected {
                    RoundedRectangle(cornerRadius: Theme.addHabitColorCircleSelectedCornerRadius)
                        .stroke(
                            LinearGradient(colors: Theme.addHabitColorCircleSelectedStrokeColors, startPoint: .top, endPoint: .bottom),
                            lineWidth: Theme.addHabitColorCircleSelectedStrokeWidth
                        )
                        .frame(width: Theme.addHabitColorCircleSelectedSize, height: Theme.addHabitColorCircleSelectedSize)
                }
            }
        }
    }
}
