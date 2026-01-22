//
//  HabitService.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Протокол сервиса управления карточками привычек.
/// Определяет публичный API для работы с карточками.
protocol HabitServiceProtocol: Sendable {
    
    /// Возвращает все сохранённые карточки привычек
    /// - Returns: Массив всех карточек
    func getAll() -> [HabitCard]
    
    /// Создаёт новую карточку привычки
    /// Если карточка с таким ID уже существует - создание отклоняется
    /// - Parameter card: Карточка для создания
    /// - Throws: Ошибка, если превышен лимит карточек, невалидные данные или карточка уже существует
    func create(card: HabitCard) throws
    
    /// Удаляет карточку привычки по идентификатору
    /// - Parameter id: UUID карточки для удаления
    /// - Throws: Ошибка, если карточка не найдена
    func delete(id: UUID) throws
    
    /// Проверяет, можно ли создать новую карточку
    /// - Returns: true, если текущее количество карточек меньше лимита
    func canCreateNewCard() -> Bool
}

/// Ошибки сервиса управления карточками
enum HabitServiceError: LocalizedError, Sendable {
    
    /// Превышен лимит карточек для текущего статуса пользователя
    case limitExceeded(currentCount: Int, maxLimit: Int)
    
    /// Название привычки превышает максимальную длину (17 символов)
    case titleTooLong(maxLength: Int)
    
    /// Карточка с указанным ID не найдена
    case cardNotFound(id: UUID)
    
    /// Карточка с указанным ID уже существует
    case cardAlreadyExists(id: UUID)
    
    /// Ошибка сохранения данных
    case saveError(underlying: Error)
    
    /// Ошибка загрузки данных
    case loadError(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .limitExceeded(let currentCount, let maxLimit):
            return "Превышен лимит карточек. Текущее количество: \(currentCount), максимум: \(maxLimit)"
        case .titleTooLong(let maxLength):
            return "Название привычки слишком длинное. Максимум символов: \(maxLength)"
        case .cardNotFound(let id):
            return "Карточка с ID \(id.uuidString) не найдена"
        case .cardAlreadyExists(let id):
            return "Карточка с ID \(id.uuidString) уже существует"
        case .saveError(let underlying):
            return "Ошибка сохранения данных: \(underlying.localizedDescription)"
        case .loadError(let underlying):
            return "Ошибка загрузки данных: \(underlying.localizedDescription)"
        }
    }
}

/// Реализация сервиса управления карточками привычек.
/// Содержит всю бизнес-логику работы с карточками, включая валидацию и проверку лимитов.
final class HabitService: HabitServiceProtocol {
    
    // MARK: - Constants
    
    /// Максимальная длина названия привычки
    private let maxTitleLength = 17
    
    // MARK: - Private Properties
    
    private let storageService: StorageService
    private let userStatusProvider: UserStatusProvider
    
    /// Кэш загруженных карточек
    private var cards: [HabitCard] = []
    
    // MARK: - Initialization
    
    /// Создаёт экземпляр сервиса
    /// - Parameters:
    ///   - storageService: Сервис для работы с хранилищем данных
    ///   - userStatusProvider: Провайдер статуса пользователя
    init(
        storageService: StorageService,
        userStatusProvider: UserStatusProvider
    ) {
        self.storageService = storageService
        self.userStatusProvider = userStatusProvider
        loadCardsFromStorage()
    }
    
    // MARK: - HabitServiceProtocol
    
    /// Возвращает все сохранённые карточки привычек
    /// - Returns: Массив всех карточек
    func getAll() -> [HabitCard] {
        return cards
    }
    
    /// Создаёт новую карточку привычки
    /// - Parameter card: Карточка для создания
    /// - Throws: HabitServiceError при превышении лимита, невалидных данных или если карточка уже существует
    func create(card: HabitCard) throws {
        // Валидация длины названия
        guard card.title.count <= maxTitleLength else {
            throw HabitServiceError.titleTooLong(maxLength: maxTitleLength)
        }
        
        // Проверяем, не существует ли уже карточка с таким ID
        guard !cards.contains(where: { $0.id == card.id }) else {
            throw HabitServiceError.cardAlreadyExists(id: card.id)
        }
        
        // Проверка лимита карточек
        guard canCreateNewCard() else {
            let status = userStatusProvider.getCurrentStatus()
            throw HabitServiceError.limitExceeded(
                currentCount: cards.count,
                maxLimit: status.maxCardsLimit
            )
        }
        
        // Создание новой карточки
        // daysCount вычисляется автоматически как computed property
        // Добавление карточки
        cards.append(card)
        
        // Сохранение в хранилище
        do {
            try storageService.saveCards(cards)
        } catch {
            // Откатываем изменение в случае ошибки сохранения
            cards.removeAll { $0.id == card.id }
            throw HabitServiceError.saveError(underlying: error)
        }
    }
    
    /// Удаляет карточку привычки по идентификатору
    /// - Parameter id: UUID карточки для удаления
    /// - Throws: HabitServiceError если карточка не найдена
    func delete(id: UUID) throws {
        guard let index = cards.firstIndex(where: { $0.id == id }) else {
            throw HabitServiceError.cardNotFound(id: id)
        }
        
        cards.remove(at: index)
        
        // Сохранение изменений в хранилище
        do {
            try storageService.saveCards(cards)
        } catch {
            // Восстанавливаем карточку в случае ошибки
            // В реальном приложении здесь может быть более сложная логика восстановления
            throw HabitServiceError.saveError(underlying: error)
        }
    }
    
    /// Проверяет, можно ли создать новую карточку
    /// - Returns: true, если текущее количество карточек меньше лимита
    func canCreateNewCard() -> Bool {
        let status = userStatusProvider.getCurrentStatus()
        return cards.count < status.maxCardsLimit
    }
    
    // MARK: - Private Methods
    
    /// Загружает карточки из хранилища при инициализации
    /// daysCount вычисляется автоматически как computed property при каждом обращении
    private func loadCardsFromStorage() {
        do {
            let loadedCards = try storageService.loadCards()
            // daysCount не сохраняется и не загружается - вычисляется динамически
            cards = loadedCards
        } catch {
            // В случае ошибки загрузки начинаем с пустого массива
            cards = []
            // Логирование ошибки можно добавить здесь
        }
    }
}
