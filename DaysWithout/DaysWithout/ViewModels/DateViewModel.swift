//
//  DateViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// Шаг экрана выбора даты/времени
enum DatePickerStep {
    case date
    case time
}

/// ViewModel экрана выбора даты и времени начала. Управляет шагами и выбранной датой; не содержит UI-кода.
@MainActor
final class DateViewModel: ObservableObject {
    @Published private(set) var step: DatePickerStep = .date
    @Published var selectedDate: Date
    
    /// Текущий месяц для отображения в календаре (только дата, время не важно)
    @Published var calendarMonth: Date
    
    private let calendar = Calendar(identifier: .gregorian)
    private let initialDate: Date
    
    /// Замыкание при подтверждении: передаётся итоговая дата
    private let onConfirm: (Date) -> Void
    /// Закрыть экран без подтверждения (кнопка «назад» на шаге даты)
    private let onDismiss: () -> Void
    
    init(initialDate: Date = Date(), onConfirm: @escaping (Date) -> Void, onDismiss: @escaping () -> Void) {
        self.initialDate = initialDate
        self.onConfirm = onConfirm
        self.onDismiss = onDismiss
        self.selectedDate = initialDate
        self.calendarMonth = calendar.startOfMonth(for: initialDate)
    }
    
    /// Обработка нажатия «назад»: переход на шаг даты или закрытие экрана
    func handleBackButtonTap() {
        Task { @MainActor in
            await Task.yield()
            if canGoBack {
                goBack()
            } else {
                onDismiss()
            }
        }
    }
    
    /// Номер дня для отображения в ячейке календаря
    func dayNumber(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
    
    var title: String {
        switch step {
        case .date: return "Дата"
        case .time: return "Время"
        }
    }
    
    var monthYearTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: calendarMonth).capitalized
    }
    
    /// Дни недели: ПН, ВТ, СР, ЧТ, ПТ, СБ, ВС (понедельник первым)
    var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEEE"
        var symbols: [String] = []
        let weekdaysOrder = [2, 3, 4, 5, 6, 7, 1]
        for weekday in weekdaysOrder {
            guard let day = calendar.date(bySetting: .weekday, value: weekday, of: Date()) else { continue }
            symbols.append(formatter.string(from: day).uppercased())
        }
        return symbols
    }
    
    /// Дни для отображения в сетке месяца (пустые места в начале — nil)
    func daysInMonth() -> [Date?] {
        let start = calendar.startOfMonth(for: calendarMonth)
        let range = calendar.range(of: .day, in: .month, for: calendarMonth)
        let count = range?.count ?? 0
        let firstWeekday = calendar.component(.weekday, from: start)
        let offset = (firstWeekday + 5) % 7
        var result: [Date?] = Array(repeating: nil, count: offset)
        for day in 1...count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: start) {
                result.append(date)
            }
        }
        return result
    }
    
    func isSelectedDay(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDate(date, inSameDayAs: selectedDate)
    }
    
    func isCurrentMonth(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDate(date, equalTo: calendarMonth, toGranularity: .month)
    }
    
    func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDateInToday(date)
    }
    
    func selectDay(_ date: Date) {
        Task { @MainActor in
            await Task.yield()
            let components = calendar.dateComponents([.year, .month, .day], from: date)
            let time = calendar.dateComponents([.hour, .minute], from: selectedDate)
            var merged = DateComponents()
            merged.year = components.year
            merged.month = components.month
            merged.day = components.day
            merged.hour = time.hour
            merged.minute = time.minute
            if let newDate = calendar.date(from: merged) {
                selectedDate = newDate
            }
        }
    }
    
    func previousMonth() {
        Task { @MainActor in
            await Task.yield()
            if let newMonth = calendar.date(byAdding: .month, value: -1, to: calendarMonth) {
                calendarMonth = calendar.startOfMonth(for: newMonth)
            }
        }
    }
    
    func nextMonth() {
        Task { @MainActor in
            await Task.yield()
            if let newMonth = calendar.date(byAdding: .month, value: 1, to: calendarMonth) {
                calendarMonth = calendar.startOfMonth(for: newMonth)
            }
        }
    }
    
    func confirmCurrentStep() {
        Task { @MainActor in
            await Task.yield()
            switch step {
            case .date:
                step = .time
            case .time:
                onConfirm(selectedDate)
            }
        }
    }
    
    func goBack() {
        Task { @MainActor in
            await Task.yield()
            switch step {
            case .date:
                break
            case .time:
                step = .date
            }
        }
    }
    
    var selectedHour: Int {
        get { calendar.component(.hour, from: selectedDate) }
        set {
            var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
            comps.hour = newValue
            if let date = calendar.date(from: comps) {
                selectedDate = date
            }
        }
    }
    
    var selectedMinute: Int {
        get { calendar.component(.minute, from: selectedDate) }
        set {
            var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: selectedDate)
            comps.minute = newValue
            if let date = calendar.date(from: comps) {
                selectedDate = date
            }
        }
    }
    
    var canGoBack: Bool {
        step == .time
    }
}

private extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let comps = dateComponents([.year, .month], from: date)
        return self.date(from: comps) ?? date
    }
}
