//
//  TimerService.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation
import Combine

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
    /// Перезапускает таймер для карточки со сбросом времени
    /// Сбрасывает startDate на текущую дату (daysCount вычисляется автоматически)
    /// - Parameter cardId: ID карточки
    /// - Throws: Ошибка, если карточка не найдена
    func restartTimer(for cardId: UUID) throws
    
    /// Возвращает оставшееся время до завершения текущего 24-часового периода
    /// - Parameter cardId: ID карточки
    /// - Returns: TimeInterval в секундах, или nil если карточка не найдена
    func getRemainingTime(for cardId: UUID) -> TimeInterval?
    
    /// Проверяет все таймеры (daysCount вычисляется автоматически как computed property)
    /// - Throws: Ошибка при обновлении карточек
    func checkAndUpdateTimers() throws
    
    /// Подписка на обновления таймера (для UI)
    /// - Parameter cardId: ID карточки
    /// - Returns: Publisher, который отправляет оставшееся время каждую секунду
    func timerUpdates(for cardId: UUID) -> AnyPublisher<TimeInterval, Never>
}

/// Реализация сервиса управления таймерами
/// Отслеживает 24-часовые периоды для каждой карточки
/// daysCount вычисляется автоматически как computed property в модели
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
    }
    
    // MARK: - TimerServiceProtocol
    
    func restartTimer(for cardId: UUID) throws {
        let cards = habitService.getAll()
        guard cards.contains(where: { $0.id == cardId }) else {
            throw TimerServiceError.cardNotFound(id: cardId)
        }
        
        // Останавливаем текущий таймер, если запущен
        stopTimerInternal(for: cardId)
        
        // На этапе 2 нет логики обновления карточек
        // Таймер просто перезапускается без изменения startDate
        // Запускаем таймер заново
        startTimerInternal(for: cardId)
    }
    
    func getRemainingTime(for cardId: UUID) -> TimeInterval? {
        // Проверяем и обновляем таймеры перед получением времени
        try? checkAndUpdateTimers()
        
        let cards = habitService.getAll()
        guard let card = cards.first(where: { $0.id == cardId }) else {
            return nil
        }
        
        // Вычисляем прошедшее время с момента startDate
        let elapsed = Date().timeIntervalSince(card.startDate)
        
        // Вычисляем прошедшее время в текущем 24-часовом периоде
        // (учитываем уже прошедшие полные периоды)
        let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.secondsInDay)
        let remaining = TimerConstants.secondsInDay - elapsedInCurrentPeriod
        
        return remaining > 0 ? remaining : 0
    }
    
    func checkAndUpdateTimers() throws {
        // daysCount теперь computed property и вычисляется автоматически
        // Не нужно обновлять его вручную - он всегда актуален
        // Метод оставлен для совместимости, но не выполняет обновлений
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
                // 24 часа прошло, daysCount автоматически обновится при следующем обращении
                // Отправляем обновлённое оставшееся время для следующего периода
                if let remaining = self.getRemainingTime(for: cardId) {
                    self.timerSubjects[cardId]?.send(remaining)
                }
            }
        }
        
        timers[cardId] = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    
    deinit {
        // Останавливаем все таймеры при деинициализации
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        timerSubjects.values.forEach { $0.send(completion: .finished) }
        timerSubjects.removeAll()
    }
}
