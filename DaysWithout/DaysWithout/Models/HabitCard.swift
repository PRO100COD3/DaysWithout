//
//  HabitCard.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Модель карточки привычки.
/// Представляет одну карточку отслеживания дней без вредной привычки.
struct HabitCard: Codable, Identifiable, Hashable, Sendable {
    
    // MARK: - Properties
    
    /// Уникальный идентификатор карточки
    let id: UUID
    
    /// Название привычки (максимум 17 символов)
    let title: String
    
    /// Дата начала отслеживания
    let startDate: Date
    
    /// Идентификатор цвета карточки
    let colorID: Int
    
    /// Количество дней без привычки (вычисляется на основе startDate и текущей даты)
    /// Не сохраняется в хранилище, всегда вычисляется динамически
    var daysCount: Int {
        let elapsed = Date().timeIntervalSince(startDate)
        let fullPeriods = Int(elapsed / TimerConstants.secondsInDay)
        return max(0, fullPeriods)
    }
    
    // MARK: - CodingKeys
    
    /// Ключи для кодирования/декодирования (исключаем daysCount из сериализации)
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case startDate
        case colorID
    }
    
    // MARK: - Initialization
    
    /// Создаёт новую карточку привычки.
    /// - Parameters:
    ///   - id: Уникальный идентификатор (по умолчанию генерируется новый)
    ///   - title: Название привычки (максимум 17 символов)
    ///   - startDate: Дата начала отслеживания
    ///   - colorID: Идентификатор цвета карточки
    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        colorID: Int
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.colorID = colorID
    }
}
