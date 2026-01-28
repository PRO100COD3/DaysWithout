//
//  AddHabitViewModel.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import Foundation
import Combine

/// ViewModel для экрана добавления привычки
/// Содержит логику валидации и создания карточки
@MainActor
final class AddHabitViewModel: ObservableObject {

    // MARK: - Published Properties
    
    /// Название привычки (вводимое пользователем)
    @Published var title: String = ""
    
    /// Выбранный цвет карточки (colorID)
    @Published var selectedColorID: Int = 1
    
    /// Сообщение об ошибке валидации (если есть)
    @Published private(set) var validationError: String?
    
    /// Можно ли создать карточку (на основе валидации)
    @Published private(set) var canCreate: Bool = false
    
    /// Текущее количество карточек (для отображения лимита)
    @Published private(set) var currentCardsCount: Int = 0
    
    /// Максимальное количество карточек (для отображения лимита)
    @Published private(set) var maxCardsLimit: Int = 3
    
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
    
    /// Создаёт новую карточку привычки
    /// - Returns: Результат создания (успех или ошибка)
    func createCard() -> Result<Void, HabitServiceError> {
        // Валидация перед созданием
        guard validateTitle() else {
            return .failure(.titleTooLong(maxLength: 17))
        }
        
        // Проверка лимита
        guard habitService.canCreateNewCard() else {
            let status = userStatusProvider.getCurrentStatus()
            return .failure(.limitExceeded(
                currentCount: currentCardsCount,
                maxLimit: status.maxCardsLimit
            ))
        }
        
        // Создание карточки
        let newCard = HabitCard(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
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
        
        // Проверка на пустоту
        guard !trimmedTitle.isEmpty else {
            validationError = nil
            return false
        }
        
        // Проверка длины
        guard trimmedTitle.count <= 17 else {
            validationError = "Название слишком длинное (максимум 17 символов)"
            return false
        }
        
        validationError = nil
        return true
    }
}
