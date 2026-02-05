//
//  AddHabitHeaderView.swift
//  DaysWithout
//

import SwiftUI

/// Заголовок модалки добавления привычки: название и счётчик карточек.
struct AddHabitHeaderView: View {
    let title: String
    let counterText: String

    init(title: String = "Создать привычку", currentCount: Int, maxCount: Int) {
        self.title = title
        self.counterText = "\(currentCount)/\(maxCount)"
    }

    var body: some View {
        HStack(spacing: Theme.addHabitHeaderSpacing) {
            Text(title)
                .font(.custom(Theme.headingFontName, size: Theme.addHabitHeaderFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.addHabitHeadingColor)
            Text(counterText)
                .font(.custom(Theme.headingFontName, size: Theme.addHabitHeaderFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.addHabitCounterColor)
        }
    }
}
