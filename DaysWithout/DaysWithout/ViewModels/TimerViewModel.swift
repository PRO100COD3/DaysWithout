//
//  TimerViewModel.swift
//  DaysWithout
//

import Foundation
import Combine
import UIKit

/// ViewModel экрана таймера привычки. Управляет состоянием таймера и валидацией; не содержит UI-кода.
@MainActor
final class TimerViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var showLimitAlert = false
    @Published var isRunning = false
    @Published var days = 0
    @Published var elapsedSeconds: TimeInterval = 0
    @Published var shouldShowRestartDialog = false
    @Published var restartReason: String = ""
    @Published var showRestartReasonLimitAlert = false
    @Published var shouldShowCloseDialog = false
    @Published var isStoryPresented = false
    @Published var isDatePickerPresented = false
    
    private var hasStarted = false
    private var restartReasonAlertHideTask: DispatchWorkItem?
    
    private var startDate: Date?
    private var savedDays: Int = 0
    private var savedElapsedSeconds: TimeInterval = 0
    
    private let card: HabitCard
    private let habitService: HabitServiceProtocol
    private let restartHistoryService: RestartHistoryServiceProtocol
    private let onClose: () -> Void
    private let userDefaults = UserDefaults.standard
    private let startDateKey: String
    private let savedDaysKey: String
    private let savedElapsedSecondsKey: String
    private let isRunningKey: String
    private let timerTextKey: String
    
    /// Максимальная длина названия (из HabitService)
    var maxLength: Int { habitService.maxTitleLength }
    /// Максимальная длина причины рестарта
    let restartReasonMaxLength = 30
    
    private var timer: Foundation.Timer?
    private let targetSeconds: TimeInterval = 24 * 60 * 60
    private var alertHideTask: DispatchWorkItem?
    
    init(card: HabitCard, habitService: HabitServiceProtocol, restartHistoryService: RestartHistoryServiceProtocol, onClose: @escaping () -> Void) {
        self.card = card
        self.habitService = habitService
        self.restartHistoryService = restartHistoryService
        self.onClose = onClose
        let prefix = "Timer_\(card.id.uuidString)"
        self.startDateKey = "\(prefix)_StartDate"
        self.savedDaysKey = "\(prefix)_SavedDays"
        self.savedElapsedSecondsKey = "\(prefix)_SavedElapsedSeconds"
        self.isRunningKey = "\(prefix)_IsRunning"
        self.timerTextKey = "\(prefix)_Text"
        self.text = card.title
        loadTimerState()
        startDisplayTimer()
        setupNotifications()
    }
    
    /// Запускает таймер обновления экрана раз в секунду (время и прогресс).
    private func startDisplayTimer() {
        timer = Foundation.Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.updateElapsedTime()
                if self.isRunning, self.elapsedSeconds >= self.targetSeconds {
                    self.completeCycle()
                }
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    var progress: Double {
        min(elapsedSeconds / targetSeconds, 1.0)
    }
    
    var timeString: String {
        let hours = Int(elapsedSeconds) / 3600
        let minutes = (Int(elapsedSeconds) % 3600) / 60
        let seconds = Int(elapsedSeconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// Карточка и сервис истории для экрана Story (доступ только для отображения).
    var cardForStory: HabitCard { card }
    var restartHistoryServiceForStory: RestartHistoryServiceProtocol { restartHistoryService }
    
    /// Начальная дата для экрана выбора даты (текущая дата начала отсчёта).
    var initialDateForDatePicker: Date { startDate ?? card.startDate }
    
    /// Обработка нажатия кнопки РЕСТАРТ (таймер всегда запущен при создании).
    func handleMainButtonTap() {
        showRestartDialog()
    }
    
    func presentStory() {
        isStoryPresented = true
    }
    
    func dismissStory() {
        isStoryPresented = false
    }
    
    func presentDatePicker() {
        isDatePickerPresented = true
    }
    
    func dismissDatePicker() {
        isDatePickerPresented = false
    }
    
    /// Вызывается после выбора даты в DateView: сохраняет дату в HabitService и перезагружает состояние таймера.
    func applyNewStartDateAndDismissPicker(_ newStartDate: Date) {
        do {
            try habitService.updateStartDate(id: card.id, startDate: newStartDate)
        } catch {
            // Игнорируем ошибку (карточка могла быть удалена)
        }
        reloadAfterStartDateChange(newStartDate: newStartDate)
        isDatePickerPresented = false
    }
    
    func handleTextChange(_ newValue: String) {
        if newValue.count > maxLength {
            text = String(newValue.prefix(maxLength))
            showCharacterLimitAlert()
        } else {
            text = newValue
        }
        
        userDefaults.set(text, forKey: timerTextKey)
        
        do {
            try habitService.updateTitle(id: card.id, title: text)
        } catch {
            // Игнорируем ошибку (карточка могла быть удалена или невалидное название)
        }
        
        if isRunning {
            saveTimerState()
        }
    }
    
    func startTimer() {
        hasStarted = true
        isRunning = true
        
        savedDays = days
        savedElapsedSeconds = elapsedSeconds
        
        if startDate == nil {
            startDate = Date()
        }
        
        saveTimerState()
    }
    
    func showRestartDialog() {
        shouldShowRestartDialog = true
    }
    
    func confirmRestart() {
        let wasRunning = isRunning
        let newStartDate = Date()
        let periodStart = startDate ?? card.startDate
        
        let record = RestartRecord(
            days: days,
            reason: restartReason,
            periodStart: periodStart,
            periodEnd: newStartDate
        )
        restartHistoryService.addRecord(cardId: card.id, record: record)
        
        do {
            try habitService.updateStartDate(id: card.id, startDate: newStartDate)
        } catch {
            // Игнорируем ошибку обновления (карточка могла быть удалена)
        }
        
        stopTimer()
        days = 0
        elapsedSeconds = 0
        restartReason = ""
        startDate = newStartDate
        savedDays = 0
        savedElapsedSeconds = 0
        clearTimerState()
        
        if wasRunning {
            startTimer()
        }
        
        shouldShowRestartDialog = false
    }
    
    func cancelRestart() {
        restartReason = ""
        shouldShowRestartDialog = false
    }
    
    func stopTimer() {
        isRunning = false
        startDate = nil
        clearTimerState()
    }
    
    func showCloseDialog() {
        shouldShowCloseDialog = true
    }
    
    func confirmClose() {
        shouldShowCloseDialog = false
        do {
            try habitService.delete(id: card.id)
        } catch {
            // Игнорируем ошибку (карточка могла быть уже удалена)
        }
        onClose()
    }
    
    func cancelClose() {
        shouldShowCloseDialog = false
    }
    
    private func tick() async {
        updateElapsedTime()
        
        if elapsedSeconds >= targetSeconds {
            completeCycle()
        }
    }
    
    private func updateElapsedTime() {
        guard let startDate = startDate else { return }
        
        let currentTime = Date()
        let totalElapsed = currentTime.timeIntervalSince(startDate) + savedElapsedSeconds
        
        let fullCycles = Int(totalElapsed / targetSeconds)
        days = savedDays + fullCycles
        
        elapsedSeconds = totalElapsed.truncatingRemainder(dividingBy: targetSeconds)
    }
    
    private func completeCycle() {
        days += 1
        savedDays = days
        elapsedSeconds = 0
        savedElapsedSeconds = 0
        startDate = Date()
        saveTimerState()
    }
        
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor [weak self] in
                await self?.applicationWillEnterForeground()
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor [weak self] in
                await self?.applicationDidEnterBackground()
            }
        }
    }
    
    @MainActor
    private func applicationWillEnterForeground() async {
        if isRunning {
            updateElapsedTime()
        }
    }
    
    @MainActor
    private func applicationDidEnterBackground() async {
        if isRunning {
            updateElapsedTime()
            saveTimerState()
        }
    }
    
    private func loadTimerState() {
        if let savedStartDate = userDefaults.object(forKey: startDateKey) as? Date {
            // Есть сохранённое время — показываем РЕСТАРТ
            hasStarted = true
            startDate = savedStartDate
            savedDays = userDefaults.integer(forKey: savedDaysKey)
            savedElapsedSeconds = userDefaults.double(forKey: savedElapsedSecondsKey)
            let wasRunning = userDefaults.bool(forKey: isRunningKey)
            isRunning = wasRunning
            
            if let savedText = userDefaults.string(forKey: timerTextKey), !savedText.isEmpty {
                text = savedText
            }
            
            updateElapsedTime()
        } else {
            // Первый запуск: таймер считается запущенным с даты карточки
            hasStarted = true
            isRunning = true
            days = card.daysCount
            startDate = card.startDate
            savedDays = card.daysCount
            savedElapsedSeconds = 0
            let totalElapsed = Date().timeIntervalSince(card.startDate)
            elapsedSeconds = totalElapsed.truncatingRemainder(dividingBy: targetSeconds)
            saveTimerState()
        }
    }
    
    private func saveTimerState() {
        if let startDate = startDate {
            userDefaults.set(startDate, forKey: startDateKey)
            userDefaults.set(savedDays, forKey: savedDaysKey)
            userDefaults.set(savedElapsedSeconds, forKey: savedElapsedSecondsKey)
            userDefaults.set(isRunning, forKey: isRunningKey)
            userDefaults.set(text, forKey: timerTextKey)
        }
    }
    
    private func clearTimerState() {
        userDefaults.removeObject(forKey: startDateKey)
        userDefaults.removeObject(forKey: savedDaysKey)
        userDefaults.removeObject(forKey: savedElapsedSecondsKey)
        userDefaults.removeObject(forKey: isRunningKey)
        userDefaults.removeObject(forKey: timerTextKey)
    }
    
    /// Перезагрузка состояния таймера после смены даты начала (из DateView).
    private func reloadAfterStartDateChange(newStartDate: Date) {
        stopTimer()
        startDate = newStartDate
        savedDays = 0
        savedElapsedSeconds = 0
        hasStarted = true
        let totalElapsed = Date().timeIntervalSince(newStartDate)
        days = Int(totalElapsed / targetSeconds)
        elapsedSeconds = totalElapsed.truncatingRemainder(dividingBy: targetSeconds)
        saveTimerState()
    }
    
    private func showCharacterLimitAlert() {
        guard !showLimitAlert else { return }
        
        showLimitAlert = true
        
        alertHideTask?.cancel()
        
        let hideTask = DispatchWorkItem { [weak self] in
            Task { @MainActor in
                self?.showLimitAlert = false
            }
        }
        alertHideTask = hideTask
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: hideTask)
    }
    
    func showRestartReasonCharacterLimitAlert() {
        guard !showRestartReasonLimitAlert else { return }
        
        showRestartReasonLimitAlert = true
        
        restartReasonAlertHideTask?.cancel()
        
        let hideTask = DispatchWorkItem { [weak self] in
            Task { @MainActor in
                self?.showRestartReasonLimitAlert = false
            }
        }
        restartReasonAlertHideTask = hideTask
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: hideTask)
    }
    
    deinit {
        timer?.invalidate()
        alertHideTask?.cancel()
        restartReasonAlertHideTask?.cancel()
        NotificationCenter.default.removeObserver(self)
    }
}
