//
//  AddHabitActionButtonsView.swift
//  DaysWithout
//

import SwiftUI

/// Кнопки ОТМЕНА и СОЗДАТЬ в модалке добавления привычки.
struct AddHabitActionButtonsView: View {
    let onCancel: () -> Void
    let onCreate: () -> Void

    var body: some View {
        HStack(spacing: Theme.addHabitButtonsSpacing) {
            Button(action: onCancel) {
                Text("ОТМЕНА")
                    .font(.custom(Theme.headingFontName, size: Theme.addHabitButtonFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.addHabitCancelButtonTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.addHabitButtonHeight)
                    .background(Theme.addHabitCancelButtonBackgroundColor)
                    .cornerRadius(Theme.addHabitButtonCornerRadius)
                    .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitButtonShadowRadius, x: 0, y: Theme.addHabitButtonShadowY)
                    .overlay {
                        RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius)
                            .stroke(Theme.addHabitCancelButtonBorderColor, lineWidth: Theme.addHabitButtonStrokeLineWidth)
                    }
            }
            Button(action: onCreate) {
                Text("СОЗДАТЬ")
                    .font(.custom(Theme.headingFontName, size: Theme.addHabitButtonFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.addHabitCreateButtonTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.addHabitButtonHeight)
                    .background(Theme.addHabitCreateButtonBackgroundColor)
                    .cornerRadius(Theme.addHabitButtonCornerRadius)
                    .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitButtonShadowRadius, x: 0, y: Theme.addHabitButtonShadowY)
                    .overlay {
                        RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius)
                            .stroke(Theme.addHabitCreateButtonBorderColor, lineWidth: Theme.addHabitButtonStrokeLineWidth)
                    }
            }
        }
    }
}
