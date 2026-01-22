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
    
    /// Количество дней без привычки (вычисляется в бизнес-логике)
    let daysCount: Int
    
    /// Идентификатор цвета карточки
    let colorID: Int
    
    // MARK: - Initialization
    
    /// Создаёт новую карточку привычки.
    /// - Parameters:
    ///   - id: Уникальный идентификатор (по умолчанию генерируется новый)
    ///   - title: Название привычки (максимум 17 символов)
    ///   - startDate: Дата начала отслеживания
    ///   - daysCount: Количество дней без привычки
    ///   - colorID: Идентификатор цвета карточки
    init(
        id: UUID = UUID(),
        title: String,
        startDate: Date,
        daysCount: Int,
        colorID: Int
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.daysCount = daysCount
        self.colorID = colorID
    }
}
