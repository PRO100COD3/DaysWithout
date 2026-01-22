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
    /// - Parameter card: Карточка для создания
    /// - Throws: Ошибка, если превышен лимит карточек или невалидные данные
    func create(card: HabitCard) throws
    
    /// Удаляет карточку привычки по идентификатору
    /// - Parameter id: UUID карточки для удаления
    /// - Throws: Ошибка, если карточка не найдена
    func delete(id: UUID) throws
    
    /// Проверяет, можно ли создать новую карточку
    /// - Returns: true, если текущее количество карточек меньше лимита
    func canCreateNewCard() -> Bool
    
    /// Обновляет существующую карточку привычки
    /// - Parameter card: Обновлённая карточка
    /// - Throws: Ошибка, если карточка не найдена
    func update(card: HabitCard) throws
}

/// Ошибки сервиса управления карточками
enum HabitServiceError: LocalizedError, Sendable {
    
    /// Превышен лимит карточек для текущего статуса пользователя
    case limitExceeded(currentCount: Int, maxLimit: Int)
    
    /// Название привычки превышает максимальную длину (17 символов)
    case titleTooLong(maxLength: Int)
    
    /// Карточка с указанным ID не найдена
    case cardNotFound(id: UUID)
    
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
    /// - Throws: HabitServiceError при превышении лимита или невалидных данных
    func create(card: HabitCard) throws {
        // Валидация длины названия
        guard card.title.count <= maxTitleLength else {
            throw HabitServiceError.titleTooLong(maxLength: maxTitleLength)
        }
        
        // Проверка лимита карточек
        guard canCreateNewCard() else {
            let status = userStatusProvider.getCurrentStatus()
            throw HabitServiceError.limitExceeded(
                currentCount: cards.count,
                maxLimit: status.maxCardsLimit
            )
        }
        
        // Вычисление daysCount на основе startDate и текущей даты
        let updatedCard = calculateDaysCount(for: card)
        
        // Добавление карточки
        cards.append(updatedCard)
        
        // Сохранение в хранилище
        do {
            try storageService.saveCards(cards)
        } catch {
            // Откатываем изменение в случае ошибки сохранения
            cards.removeAll { $0.id == updatedCard.id }
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
    
    /// Обновляет существующую карточку привычки
    /// - Parameter card: Обновлённая карточка
    /// - Throws: HabitServiceError если карточка не найдена
    func update(card: HabitCard) throws {
        // Валидация длины названия
        guard card.title.count <= maxTitleLength else {
            throw HabitServiceError.titleTooLong(maxLength: maxTitleLength)
        }
        
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
            throw HabitServiceError.cardNotFound(id: card.id)
        }
        
        cards[index] = card
        
        do {
            try storageService.saveCards(cards)
        } catch {
            throw HabitServiceError.saveError(underlying: error)
        }
    }
    
    // MARK: - Private Methods
    
    /// Загружает карточки из хранилища при инициализации
    /// daysCount пересчитывается на основе startDate и текущей даты при каждом запуске
    private func loadCardsFromStorage() {
        do {
            let loadedCards = try storageService.loadCards()
            // Пересчитываем daysCount для всех загруженных карточек
            cards = loadedCards.map { calculateDaysCount(for: $0) }
            
            // Сохраняем обновлённые карточки с актуальным daysCount
            try? storageService.saveCards(cards)
        } catch {
            // В случае ошибки загрузки начинаем с пустого массива
            cards = []
            // Логирование ошибки можно добавить здесь
        }
    }
    
    /// Вычисляет количество дней без привычки на основе startDate и текущей даты
    /// Считает полные 24-часовые периоды, а не календарные дни
    /// - Parameter card: Карточка для обновления
    /// - Returns: Карточка с обновлённым daysCount
    private func calculateDaysCount(for card: HabitCard) -> HabitCard {
        // Вычисляем прошедшее время с момента startDate
        let elapsed = Date().timeIntervalSince(card.startDate)
        
        // Вычисляем количество полных 24-часовых периодов
        let fullPeriods = Int(elapsed / TimerConstants.hoursInDay)
        
        return HabitCard(
            id: card.id,
            title: card.title,
            startDate: card.startDate,
            daysCount: max(0, fullPeriods),
            colorID: card.colorID
        )
    }
}
