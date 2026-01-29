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

/// Результат попытки создания карточки
enum AddHabitCreateOutcome: Sendable {
    case success
    case validationFailed(AddHabitValidationReason)
    case serviceError(HabitServiceError)
}

/// ViewModel для экрана добавления привычки
/// Содержит логику валидации и создания карточки; не содержит UI-строк
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
    
    /// Максимальная длина названия (из Theme; в HabitService — своя константа)
    var maxTitleLength: Int { Theme.addHabitMaxTitleLength }
    
    // MARK: - Private Properties
    
    private let habitService: HabitServiceProtocol
    private let userStatusProvider: UserStatusProvider
    private var cancellables = Set<AnyCancellable>()

    
    // MARK: - Initialization
    
    /// Создаёт экземпляр ViewModel
    /// - Parameters:
    ///   - habitService: Сервис для работы с карточками
    ///   - userStatusProvider: Провайдер статуса пользователя
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider
    ) {
        self.habitService = habitService
        self.userStatusProvider = userStatusProvider
        
        // Загружаем начальные данные
        updateCardsInfo()
        
        // Подписываемся на изменения названия для валидации
        $title
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.canCreate = self.validateTitle()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /// Пытается создать карточку: валидация в ViewModel, результат без UI-строк.
    /// View отображает сообщения через Theme по ValidationReason.
    /// - Returns: Успех, причина валидации или ошибка сервиса
    func attemptCreate() -> AddHabitCreateOutcome {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return .validationFailed(.emptyTitle)
        }
        if trimmed.count > Theme.addHabitMaxTitleLength {
            return .validationFailed(.titleTooLong(maxLength: Theme.addHabitMaxTitleLength))
        }
        
        switch createCard() {
        case .success:
            return .success
        case .failure(let error):
            return .serviceError(error)
        }
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
        
        guard trimmedTitle.count <= Theme.addHabitMaxTitleLength else {
            return false
        }
        
        return true
    }
}
