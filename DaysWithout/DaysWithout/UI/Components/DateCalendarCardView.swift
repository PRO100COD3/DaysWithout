//
//  DateCalendarCardView.swift
//  DaysWithout
//

import SwiftUI

/// Карточка календаря: навигация по месяцам, строки недели, сетка дней и кнопка «СОЗДАТЬ».
struct DateCalendarCardView: View {
    let monthYearTitle: String
    let weekdaySymbols: [String]
    let days: [Date?]
    let dayNumber: (Date) -> Int
    let isSelectedDay: (Date) -> Bool
    let isToday: (Date) -> Bool
    let isCurrentMonth: (Date) -> Bool
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onSelectDay: (Date) -> Void
    let onConfirm: () -> Void

    var body: some View {
        DateStepCardView {
            VStack(spacing: Theme.dateContentStackSpacing) {
                VStack(spacing: Theme.dateCalendarCardSpacing) {
                    monthNavigationView
                    weekdayRowView
                    daysGridView
                }
                DateCreateButtonView(action: onConfirm)
                    .shadow(color: Color.black.opacity(Theme.storyHistoryCellStrokeOpacity), radius: Theme.dateCalendarCardButtonShadowRadius, x: 0, y: Theme.dateCalendarCardButtonShadowY)
            }
        }
    }

    private var monthNavigationView: some View {
        HStack {
            Button(action: onPreviousMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: Theme.dateCalendarNavButtonFontSize, weight: .semibold))
                    .foregroundColor(Theme.dateCalendarNavGreen)
                    .padding(Theme.dateCalendarNavButtonPadding)
            }
            Spacer()
            Text(monthYearTitle)
                .font(.custom(Theme.headingFontName, size: Theme.dateCalendarMonthFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.mainHeadingColor)
            Spacer()
            Button(action: onNextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: Theme.dateCalendarNavButtonFontSize, weight: .semibold))
                    .foregroundColor(Theme.dateCalendarNavGreen)
                    .padding(Theme.dateCalendarNavButtonPadding)
            }
        }
    }

    private var weekdayRowView: some View {
        HStack(spacing: Theme.dateContentStackSpacing) {
            ForEach(Array(weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                Text(symbol)
                    .font(.custom(Theme.headingFontName, size: Theme.dateCalendarWeekdayFontSize))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.dateCalendarWeekdayColor)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var daysGridView: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: Theme.dateCalendarGridItemSpacing), count: Theme.dateCalendarWeekdayColumnCount)
        return LazyVGrid(columns: columns, spacing: Theme.dateCalendarGridRowSpacing) {
            ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                if let date = day {
                    dayCell(for: date)
                } else {
                    Color.clear
                        .frame(width: Theme.dateCalendarEmptyCellSize, height: Theme.dateCalendarEmptyCellSize)
                }
            }
        }
    }

    private func dayCell(for date: Date) -> some View {
        let selected = isSelectedDay(date)
        let isTodayDate = isToday(date)
        let inMonth = isCurrentMonth(date)
        return Button(action: { onSelectDay(date) }) {
            Text("\(dayNumber(date))")
                .font(.custom(Theme.headingFontName, size: Theme.dateCalendarDayFontSize))
                .fontWeight(.regular)
                .foregroundColor((selected || isTodayDate) ? Theme.dateCalendarNavGreen : (inMonth ? Theme.mainHeadingColor : Theme.mainDescriptionColor))
                .frame(width: Theme.dateCalendarDayCellSize, height: Theme.dateCalendarDayCellSize)
                .background(
                    Circle()
                        .fill(selected ? Theme.dateCalendarDaySelectedBackground : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
}
