//
//  UserStatusProvider.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Протокол для получения статуса пользователя.
/// Позволяет легко заменить временную реализацию на реальную подписку в будущем.
protocol UserStatusProvider: Sendable {
    
    /// Возвращает текущий статус пользователя
    func getCurrentStatus() -> UserStatus
}

/// Временная реализация провайдера статуса пользователя.
/// На данном этапе всегда возвращает Free статус.
/// В будущем может быть заменён на реальную интеграцию с StoreKit.
final class DefaultUserStatusProvider: UserStatusProvider {
    
    // MARK: - UserStatusProvider
    
    func getCurrentStatus() -> UserStatus {
        // Временная реализация: всегда возвращаем Free
        // На следующих этапах здесь будет логика проверки подписки
        return .free
    }
}
