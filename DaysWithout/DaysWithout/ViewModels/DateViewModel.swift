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
    var onConfirm: ((Date) -> Void)?
    
    init(initialDate: Date = Date()) {
        self.initialDate = initialDate
        self.selectedDate = initialDate
        self.calendarMonth = calendar.startOfMonth(for: initialDate)
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
    
    var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEEE"
        var symbols: [String] = []
        for i in 2...8 {
            guard let day = calendar.date(bySetting: .weekday, value: i, of: Date()) else { continue }
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
    
    func selectDay(_ date: Date) {
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
    
    func previousMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: calendarMonth) {
            calendarMonth = calendar.startOfMonth(for: newMonth)
        }
    }
    
    func nextMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: calendarMonth) {
            calendarMonth = calendar.startOfMonth(for: newMonth)
        }
    }
    
    func confirmCurrentStep() {
        switch step {
        case .date:
            step = .time
        case .time:
            onConfirm?(selectedDate)
        }
    }
    
    func goBack() {
        switch step {
        case .date:
            break
        case .time:
            step = .date
        }
    }
    
    var selectedHour: Int {
        get { calendar.component(.hour, from: selectedDate) }
        set {
            if let date = calendar.date(bySetting: .hour, value: newValue, of: selectedDate) {
                selectedDate = date
            }
        }
    }
    
    var selectedMinute: Int {
        get { calendar.component(.minute, from: selectedDate) }
        set {
            if let date = calendar.date(bySetting: .minute, value: newValue, of: selectedDate) {
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
