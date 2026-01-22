//
//  StorageService.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Протокол для работы с хранилищем данных.
/// Абстрагирует детали реализации хранения (UserDefaults/FileManager).
protocol StorageService: Sendable {
    
    /// Сохраняет массив карточек привычек
    /// - Parameter cards: Массив карточек для сохранения
    func saveCards(_ cards: [HabitCard]) throws
    
    /// Загружает сохранённые карточки привычек
    /// - Returns: Массив карточек или пустой массив, если данных нет
    func loadCards() throws -> [HabitCard]
    
    /// Полностью очищает все сохранённые данные
    func clearAll() throws
}

/// Реализация хранилища через UserDefaults.
/// Использует Codable для сериализации данных.
final class UserDefaultsStorageService: StorageService {
    
    // MARK: - Constants
    
    private let storageKey = "com.dayswithout.habitcards"
    
    // MARK: - StorageService
    
    func saveCards(_ cards: [HabitCard]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(cards)
        UserDefaults.standard.set(data, forKey: storageKey)
    }
    
    func loadCards() throws -> [HabitCard] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return []
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([HabitCard].self, from: data)
    }
    
    func clearAll() throws {
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
