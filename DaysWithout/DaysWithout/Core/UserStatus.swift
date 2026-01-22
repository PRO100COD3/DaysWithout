//
//  UserStatus.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Статус пользователя в приложении.
/// Определяет лимиты на количество карточек привычек.
enum UserStatus: String, Codable, Sendable {
    
    // MARK: - Cases
    
    /// Бесплатный статус — максимум 3 карточки
    case free
    
    /// Платный статус — максимум 6 карточек
    case pro
    
    // MARK: - Properties
    
    /// Максимальное количество карточек для текущего статуса
    var maxCardsLimit: Int {
        switch self {
        case .free:
            return 3
        case .pro:
            return 6
        }
    }
}
