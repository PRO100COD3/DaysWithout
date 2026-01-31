//
//  AddHabitViewModel.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import Foundation
import Combine

/// Причина ошибки валидации (без UI-строк; View маппит в Theme)
enum AddHabitValidationReason: Sendable {
    case emptyTitle
    case titleTooLong(maxLength: Int)
}

/// ViewModel для экрана добавления привычки
/// Содержит логику валидации, создания карточки и состояния алерта; не содержит UI-строк
@MainActor
final class AddHabitViewModel: ObservableObject {

    // MARK: - Published Properties
    
    /// Название привычки (вводимое пользователем)
    @Published var title: String = ""
    
    /// Выбранный цвет карточки (colorID)
    @Published var selectedColorID: Int = 1
    
    /// Можно ли создать карточку (на основе валидации)
    @Published private(set) var canCreate: Bool = false
    
    /// Текущее количество карточек (для отображения лимита)
    @Published private(set) var currentCardsCount: Int = 0
    
    /// Максимальное количество карточек (для отображения лимита)
    @Published private(set) var maxCardsLimit: Int = 3
    
    /// Максимальная длина названия (из HabitService)
    var maxTitleLength: Int { habitService.maxTitleLength }
    
    /// Сообщение алерта валидации (nil = алерт скрыт). View только отображает по биндингу.
    @Published private(set) var alertMessage: String?
    
    // MARK: - Private Properties
    
    private let habitService: HabitServiceProtocol
    private let userStatusProvider: UserStatusProvider
    private let onDismiss: () -> Void
    private let alertDisplayDuration: TimeInterval
    private let alertMessageForValidation: (AddHabitValidationReason) -> String
    private let alertMessageForServiceError: (HabitServiceError) -> String?
    private var cancellables = Set<AnyCancellable>()
    private var alertDismissWorkItem: DispatchWorkItem?
    
    // MARK: - Initialization
    
    /// Создаёт экземпляр ViewModel
    /// - Parameters:
    ///   - habitService: Сервис для работы с карточками
    ///   - userStatusProvider: Провайдер статуса пользователя
    ///   - onDismiss: Замыкание для закрытия экрана (вызывается при успехе или limitExceeded)
    ///   - alertDisplayDuration: Длительность показа алерта (сек)
    ///   - alertMessageForValidation: Маппинг причины валидации в строку для UI
    ///   - alertMessageForServiceError: Маппинг ошибки сервиса в строку для алерта (nil = не показывать)
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider,
        onDismiss: @escaping () -> Void,
        alertDisplayDuration: TimeInterval,
        alertMessageForValidation: @escaping (AddHabitValidationReason) -> String,
        alertMessageForServiceError: @escaping (HabitServiceError) -> String?
    ) {
        self.habitService = habitService
        self.userStatusProvider = userStatusProvider
        self.onDismiss = onDismiss
        self.alertDisplayDuration = alertDisplayDuration
        self.alertMessageForValidation = alertMessageForValidation
        self.alertMessageForServiceError = alertMessageForServiceError
        
        updateCardsInfo()
        
        $title
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.canCreate = self.validateTitle()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /// Пытается создать карточку. Обрабатывает результат внутри: показывает алерт или закрывает экран.
    /// View только биндится к alertMessage и отображает состояние.
    func attemptCreate() {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            showAlertTemporarily(alertMessageForValidation(.emptyTitle))
            return
        }
        if trimmed.count > maxTitleLength {
            showAlertTemporarily(alertMessageForValidation(.titleTooLong(maxLength: maxTitleLength)))
            return
        }
        
        switch createCard() {
        case .success:
            onDismiss()
        case .failure(let error):
            if case .limitExceeded = error {
                onDismiss()
            } else if let message = alertMessageForServiceError(error), !message.isEmpty {
                showAlertTemporarily(message)
            } else {
                clearAlert()
            }
        }
    }
    
    /// Скрыть алерт (вызывается из View при необходимости)
    func clearAlert() {
        cancelAlertTimer()
        alertMessage = nil
    }
    
    // MARK: - Private Methods
    
    private func showAlertTemporarily(_ message: String) {
        cancelAlertTimer()
        alertMessage = message
        let workItem = DispatchWorkItem { [weak self] in
            self?.alertMessage = nil
        }
        alertDismissWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + alertDisplayDuration, execute: workItem)
    }
    
    private func cancelAlertTimer() {
        alertDismissWorkItem?.cancel()
        alertDismissWorkItem = nil
    }
    
    /// Создаёт новую карточку привычки (внутренний метод; вызывается после валидации)
    /// - Returns: Результат создания (успех или ошибка)
    private func createCard() -> Result<Void, HabitServiceError> {
        guard habitService.canCreateNewCard() else {
            let status = userStatusProvider.getCurrentStatus()
            return .failure(.limitExceeded(
                currentCount: currentCardsCount,
                maxLimit: status.maxCardsLimit
            ))
        }
        
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let newCard = HabitCard(
            title: trimmed,
            startDate: Date(),
            colorID: selectedColorID
        )
        
        do {
            try habitService.create(card: newCard)
            return .success(())
        } catch let error as HabitServiceError {
            return .failure(error)
        } catch {
            return .failure(.saveError(underlying: error))
        }
    }
    
    /// Обновляет информацию о количестве карточек
    func updateCardsInfo() {
        currentCardsCount = habitService.getAll().count
        let status = userStatusProvider.getCurrentStatus()
        maxCardsLimit = status.maxCardsLimit
    }
    
    // MARK: - Private Methods
    
    /// Валидирует название привычки
    /// - Returns: true, если название валидно
    private func validateTitle() -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            return false
        }
        
        guard trimmedTitle.count <= maxTitleLength else {
            return false
        }
        
        return true
    }
}
