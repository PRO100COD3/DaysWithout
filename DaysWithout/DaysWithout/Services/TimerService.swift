//
//  TimerService.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation
import Combine
import SwiftUI

/// Ошибки сервиса таймеров
enum TimerServiceError: LocalizedError, Sendable {
    case cardNotFound(id: UUID)
    
    var errorDescription: String? {
        switch self {
        case .cardNotFound(let id):
            return "Карточка с ID \(id.uuidString) не найдена"
        }
    }
}

/// Протокол сервиса управления таймерами для карточек привычек
protocol TimerServiceProtocol: Sendable {
    /// Перезапускает таймер для карточки со сбросом времени и количества дней
    /// Сбрасывает startDate на текущую дату и daysCount на 0, затем запускает таймер
    /// - Parameter cardId: ID карточки
    /// - Throws: Ошибка, если карточка не найдена
    func restartTimer(for cardId: UUID) throws
    
    /// Возвращает оставшееся время до завершения текущего 24-часового периода
    /// - Parameter cardId: ID карточки
    /// - Returns: TimeInterval в секундах, или nil если карточка не найдена
    func getRemainingTime(for cardId: UUID) -> TimeInterval?
    
    /// Проверяет все таймеры и обновляет daysCount при достижении 24 часов
    /// - Throws: Ошибка при обновлении карточек
    func checkAndUpdateTimers() throws
    
    /// Подписка на обновления таймера (для UI)
    /// - Parameter cardId: ID карточки
    /// - Returns: Publisher, который отправляет оставшееся время каждую секунду
    func timerUpdates(for cardId: UUID) -> AnyPublisher<TimeInterval, Never>
}

/// Реализация сервиса управления таймерами
/// Отслеживает 24-часовые периоды для каждой карточки и обновляет daysCount
final class TimerService: TimerServiceProtocol {
    
    // MARK: - Private Properties
    
    private let habitService: HabitServiceProtocol
    private var timers: [UUID: Timer] = [:]
    private var timerSubjects: [UUID: PassthroughSubject<TimeInterval, Never>] = [:]
    
    // MARK: - Initialization
    
    /// Создаёт экземпляр сервиса таймеров
    /// - Parameter habitService: Сервис для работы с карточками привычек
    init(habitService: HabitServiceProtocol) {
        self.habitService = habitService
        setupAppLifecycleObservers()
    }
    
    // MARK: - TimerServiceProtocol
    
    func restartTimer(for cardId: UUID) throws {
        let cards = habitService.getAll()
        guard let card = cards.first(where: { $0.id == cardId }) else {
            throw TimerServiceError.cardNotFound(id: cardId)
        }
        
        // Останавливаем текущий таймер, если запущен
        stopTimerInternal(for: cardId)
        
        // Сбрасываем startDate на текущую дату и daysCount на 0
        let resetCard = HabitCard(
            id: card.id,
            title: card.title,
            startDate: Date(),
            daysCount: 0,
            colorID: card.colorID
        )
        
        // Обновляем карточку
        try habitService.update(card: resetCard)
        
        // Запускаем таймер заново
        startTimerInternal(for: cardId)
    }
    
    func getRemainingTime(for cardId: UUID) -> TimeInterval? {
        let cards = habitService.getAll()
        guard let card = cards.first(where: { $0.id == cardId }) else {
            return nil
        }
        
        // Вычисляем прошедшее время с момента startDate
        let elapsed = Date().timeIntervalSince(card.startDate)
        
        // Вычисляем прошедшее время в текущем 24-часовом периоде
        // (учитываем уже прошедшие полные периоды)
        let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.hoursInDay)
        let remaining = TimerConstants.hoursInDay - elapsedInCurrentPeriod
        
        return remaining > 0 ? remaining : 0
    }
    
    func checkAndUpdateTimers() throws {
        let cards = habitService.getAll()
        
        for card in cards {
            // Вычисляем прошедшее время с момента startDate
            let elapsed = Date().timeIntervalSince(card.startDate)
            
            // Вычисляем количество полных 24-часовых периодов
            let fullPeriods = Int(elapsed / TimerConstants.hoursInDay)
            
            // Обновляем daysCount только если прошло больше периодов, чем текущее значение
            // daysCount уже хранится в карточке, не пересчитываем каждый раз
            if fullPeriods > card.daysCount {
                let updatedCard = HabitCard(
                    id: card.id,
                    title: card.title,
                    startDate: card.startDate, // startDate не меняется!
                    daysCount: fullPeriods, // Обновляем только при достижении нового периода
                    colorID: card.colorID
                )
                
                // Обновляем через HabitService
                try habitService.update(card: updatedCard)
            }
        }
    }
    
    func timerUpdates(for cardId: UUID) -> AnyPublisher<TimeInterval, Never> {
        if timerSubjects[cardId] == nil {
            timerSubjects[cardId] = PassthroughSubject<TimeInterval, Never>()
        }
        return timerSubjects[cardId]!.eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    /// Внутренний метод для остановки таймера
    /// - Parameter cardId: ID карточки
    private func stopTimerInternal(for cardId: UUID) {
        timers[cardId]?.invalidate()
        timers.removeValue(forKey: cardId)
        timerSubjects[cardId]?.send(completion: .finished)
        timerSubjects.removeValue(forKey: cardId)
    }
    
    /// Внутренний метод для запуска таймера
    /// - Parameter cardId: ID карточки
    private func startTimerInternal(for cardId: UUID) {
        // Создаём новый subject, если его нет
        if timerSubjects[cardId] == nil {
            timerSubjects[cardId] = PassthroughSubject<TimeInterval, Never>()
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            // Получаем оставшееся время
            if let remaining = self.getRemainingTime(for: cardId), remaining > 0 {
                // Отправляем обновление каждую секунду
                self.timerSubjects[cardId]?.send(remaining)
            } else {
                // 24 часа прошло, проверяем и обновляем daysCount
                try? self.checkAndUpdateTimers()
                
                // Отправляем обновлённое оставшееся время для следующего периода
                if let remaining = self.getRemainingTime(for: cardId) {
                    self.timerSubjects[cardId]?.send(remaining)
                }
            }
        }
        
        timers[cardId] = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    
    /// Настройка наблюдателей за жизненным циклом приложения
    private func setupAppLifecycleObservers() {
        #if canImport(UIKit)
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // При активации приложения проверяем таймеры
            // Это гарантирует, что daysCount обновится даже если приложение было закрыто
            try? self?.checkAndUpdateTimers()
        }
        #endif
    }
    
    deinit {
        // Останавливаем все таймеры при деинициализации
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        timerSubjects.values.forEach { $0.send(completion: .finished) }
        timerSubjects.removeAll()
        NotificationCenter.default.removeObserver(self)
    }
}
