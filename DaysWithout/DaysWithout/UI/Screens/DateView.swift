//
//  DateView.swift
//  DaysWithout
//

import SwiftUI

/// Экран поочерёдного выбора даты (календарь) и времени (циферблат), затем сохранение новой даты начала.
struct DateView: View {
    let initialDate: Date
    let onConfirm: (Date) -> Void
    let onDismiss: () -> Void

    @StateObject private var viewModel: DateViewModel

    init(initialDate: Date, onConfirm: @escaping (Date) -> Void, onDismiss: @escaping () -> Void) {
        self.initialDate = initialDate
        self.onConfirm = onConfirm
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: DateViewModel(initialDate: initialDate, onConfirm: onConfirm, onDismiss: onDismiss))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.backgroundColor[0], Theme.backgroundColor[1]], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: Theme.dateContentStackSpacing) {
                ScreenHeaderView(
                    title: viewModel.title,
                    titleFontSize: Theme.dateHeaderTitleFontSize,
                    titleColor: Theme.mainHeadingColor,
                    horizontalPadding: Theme.dateHeaderHorizontalPadding,
                    topPadding: 0,
                    leading: {
                        Button(action: viewModel.handleBackButtonTap) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: Theme.dateHeaderChevronFontSize, weight: .semibold))
                                .foregroundColor(Theme.mainHeadingColor)
                        }
                        .frame(width: Theme.dateHeaderBackButtonSize, height: Theme.dateHeaderBackButtonSize)
                    },
                    trailing: {
                        Color.clear
                            .frame(width: Theme.dateHeaderPlaceholderSize.width, height: Theme.dateHeaderPlaceholderSize.height)
                    }
                )
                Spacer()
                contentView
                    .padding(.horizontal, Theme.dateContentHorizontalPadding)
                Spacer()
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.step {
        case .date:
            DateCalendarCardView(
                monthYearTitle: viewModel.monthYearTitle,
                weekdaySymbols: viewModel.weekdaySymbols,
                days: viewModel.daysInMonth(),
                dayNumber: viewModel.dayNumber(for:),
                isSelectedDay: { viewModel.isSelectedDay($0) },
                isToday: { viewModel.isToday($0) },
                isCurrentMonth: { viewModel.isCurrentMonth($0) },
                onPreviousMonth: viewModel.previousMonth,
                onNextMonth: viewModel.nextMonth,
                onSelectDay: viewModel.selectDay,
                onConfirm: viewModel.confirmCurrentStep
            )
        case .time:
            DateTimeCardView(
                hourSelection: Binding(
                    get: { viewModel.selectedHour },
                    set: { viewModel.selectedHour = $0 }
                ),
                minuteSelection: Binding(
                    get: { viewModel.selectedMinute },
                    set: { viewModel.selectedMinute = $0 }
                ),
                onConfirm: viewModel.confirmCurrentStep
            )
        }
    }
}

#Preview {
    DateView(
        initialDate: Date(),
        onConfirm: { _ in },
        onDismiss: {}
    )
}
