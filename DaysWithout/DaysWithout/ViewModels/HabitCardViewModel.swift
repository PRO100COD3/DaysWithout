//
//  HabitCardViewModel.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import Foundation
import Combine

/// ViewModel для карточки привычки
/// Содержит логику таймера и расчетов, изолированную от UI
@MainActor
final class HabitCardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Оставшееся время до завершения 24-часового периода (в секундах)
    @Published private(set) var remainingTime: TimeInterval = 0
    
    /// Значение прогресса для прогресс-ринга (0.0 - 1.0)
    @Published private(set) var progressValue: Double = 0.0
    
    /// Состояние нажатия (для анимации; таймер реверта управляется во ViewModel)
    @Published private(set) var isPressed: Bool = false
    
    // MARK: - Private Properties
    
    private var card: HabitCard
    private let timerService: TimerServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var updateTimer: Timer?
    
    // MARK: - Initialization
    
    /// Создаёт экземпляр ViewModel для карточки
    /// - Parameters:
    ///   - card: Карточка привычки
    ///   - timerService: Сервис таймеров
    init(
        card: HabitCard,
        timerService: TimerServiceProtocol
    ) {
        self.card = card
        self.timerService = timerService
        setupTimer()
    }
    
    // MARK: - Public Methods
    
    /// Строковое представление таймера (формат HH:MM - часы:минуты)
    var timerString: String {
        let totalSeconds = Int(remainingTime)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    /// Обновляет карточку (например, после рестарта на экране Timer). Пересчитывает прогресс и таймер.
    func updateCard(_ card: HabitCard) {
        self.card = card
        updateValues()
    }
    
    /// Запускает анимацию нажатия: устанавливает isPressed = true, через duration возвращает false.
    /// Длительность передаётся из View (Theme), чтобы ViewModel не зависел от UI.
    func triggerPress(duration: TimeInterval) {
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.isPressed = false
        }
    }
    
    // MARK: - Private Methods
    
    /// Настраивает таймер для обновления значений
    private func setupTimer() {
        // Получаем начальное значение
        updateValues()
        
        // Создаём таймер для обновления каждую секунду
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor [weak self] in
                self?.updateValues()
            }
        }
        
        if let timer = updateTimer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    /// Обновляет значения таймера и прогресса
    private func updateValues() {
        // Получаем оставшееся время из сервиса
        if let remaining = timerService.getRemainingTime(for: card.id) {
            remainingTime = remaining
        }
        
        // Вычисляем прогресс в текущем 24-часовом периоде
        let elapsed = Date().timeIntervalSince(card.startDate)
        let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.secondsInDay)
        progressValue = min(elapsedInCurrentPeriod / TimerConstants.secondsInDay, 1.0)
    }
    
    deinit {
        updateTimer?.invalidate()
        cancellables.removeAll()
    }
}
