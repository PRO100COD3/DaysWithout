//
//  StoryViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// ViewModel экрана истории рестартов. Предоставляет список записей из сервиса; не содержит UI-кода.
@MainActor
final class StoryViewModel: ObservableObject {
    @Published private(set) var history: [RestartRecord] = []
    
    private let card: HabitCard
    private let restartHistoryService: RestartHistoryServiceProtocol
    
    init(card: HabitCard, restartHistoryService: RestartHistoryServiceProtocol) {
        self.card = card
        self.restartHistoryService = restartHistoryService
        loadHistory()
    }
    
    var cardTitle: String {
        card.title
    }
    
    var isEmpty: Bool {
        history.isEmpty
    }
    
    /// Форматирует диапазон дат для отображения (dd.MM.yyyy – dd.MM.yyyy)
    static func formatDateRange(periodStart: Date, periodEnd: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return "\(formatter.string(from: periodStart)) – \(formatter.string(from: periodEnd))"
    }
    
    /// Склонение "день/дня/дней" для числа
    static func daysText(for count: Int) -> String {
        let mod10 = count % 10
        let mod100 = count % 100
        if mod100 >= 11 && mod100 <= 19 {
            return "\(count) дней"
        }
        switch mod10 {
        case 1: return "\(count) день"
        case 2, 3, 4: return "\(count) дня"
        default: return "\(count) дней"
        }
    }
    
    func loadHistory() {
        history = restartHistoryService.getHistory(cardId: card.id)
    }
}
