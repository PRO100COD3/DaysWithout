//
//  StoryViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// ViewModel экрана истории рестартов. Предоставляет список записей из сервиса и навигацию Support → SelectPurchases; не содержит UI-кода.
@MainActor
final class StoryViewModel: ObservableObject {
    @Published private(set) var history: [RestartRecord] = []
    
    /// Показан ли экран «Поддержать разработчика»
    @Published var isSupportPresented: Bool = false
    
    /// Показан ли экран выбора подписки (поверх Support)
    @Published var isSelectPurchasesPresented: Bool = false
    
    private let card: HabitCard
    private let restartHistoryService: RestartHistoryServiceProtocol
    /// Закрыть весь экран Story (вызывается при закрытии флоу поддержки после успешной покупки)
    private let onFullDismiss: () -> Void
    
    init(card: HabitCard, restartHistoryService: RestartHistoryServiceProtocol, onFullDismiss: @escaping () -> Void) {
        self.card = card
        self.restartHistoryService = restartHistoryService
        self.onFullDismiss = onFullDismiss
    }
    
    // MARK: - Навигация флоу поддержки
    
    /// Открыть экран Support (кнопка coins)
    func openSupport() {
        Task { @MainActor in
            await Task.yield()
            isSupportPresented = true
        }
    }
    
    /// Открыть экран выбора подписки (кнопка «ПОДДЕРЖАТЬ»). Скрывает Support.
    func openSelectPurchases() {
        Task { @MainActor in
            await Task.yield()
            isSupportPresented = false
            isSelectPurchasesPresented = true
        }
    }
    
    /// Закрыть только экраны подписки (Support, SelectPurchases, Success), Story остаётся открытым (крестик, тап мимо)
    func dismissSupportFlowKeepStory() {
        Task { @MainActor in
            await Task.yield()
            isSelectPurchasesPresented = false
            isSupportPresented = false
        }
    }
    
    /// Закрыть весь флоу поддержки и экран Story («СПАСИБО» после успешной покупки)
    func dismissEntireSupportFlow() {
        Task { @MainActor in
            await Task.yield()
            isSelectPurchasesPresented = false
            isSupportPresented = false
            onFullDismiss()
        }
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
        Task { @MainActor in
            await Task.yield()
            history = restartHistoryService.getHistory(cardId: card.id)
        }
    }
}
