//
//  AddHabitTitleInputView.swift
//  DaysWithout
//

import SwiftUI

/// Поле ввода названия привычки с оформлением и состоянием ошибки.
struct AddHabitTitleInputView: View {
    let placeholder: String
    @Binding var text: String
    let hasError: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.addHabitInputInternalSpacing) {
            TextField(placeholder, text: $text)
                .multilineTextAlignment(.center)
                .font(.custom(Theme.headingFontName, size: Theme.addHabitInputFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.addHabitInputTextColor)
                .padding(.horizontal, Theme.addHabitInputPaddingH)
                .padding(.vertical, Theme.addHabitInputPaddingV)
                .background(Theme.addHabitInputBackgroundColor)
                .overlay {
                    RoundedRectangle(cornerRadius: Theme.addHabitInputCornerRadius)
                        .stroke(
                            hasError ? Theme.addHabitInputBorderColorError : Theme.addHabitInputBorderColorNormal,
                            lineWidth: Theme.addHabitInputBorderLineWidth
                        )
                }
                .cornerRadius(Theme.addHabitInputCornerRadius)
                .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitInputShadowRadius, x: 0, y: Theme.addHabitInputShadowY)
        }
    }
}
