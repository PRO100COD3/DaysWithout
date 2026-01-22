//
//  ExampleUsage.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation

/// Пример использования бизнес-логики без UI.
/// Демонстрирует создание, удаление карточек и проверку лимитов.
/// 
/// ВАЖНО: Этот файл создан только для демонстрации API.
/// В реальном приложении эта логика будет использоваться через ViewModel.
final class ExampleUsage {
    
    // MARK: - Properties
    
    private let habitService: HabitServiceProtocol
    
    // MARK: - Initialization
    
    init() {
        // Создаём зависимости
        let storageService = UserDefaultsStorageService()
        let userStatusProvider = DefaultUserStatusProvider()
        
        // Инициализируем сервис
        self.habitService = HabitService(
            storageService: storageService,
            userStatusProvider: userStatusProvider
        )
    }
    
    // MARK: - Example Methods
    
    /// Демонстрирует создание карточки привычки
    func exampleCreateCard() {
        print("=== Пример создания карточки ===")
        
        // Проверяем, можно ли создать новую карточку
        if habitService.canCreateNewCard() {
            print("✅ Можно создать новую карточку")
            
            // Создаём новую карточку
            let newCard = HabitCard(
                title: "Курение",
                startDate: Date(),
                daysCount: 0, // Будет пересчитано автоматически
                colorID: 1
            )
            
            do {
                try habitService.create(card: newCard)
                print("✅ Карточка успешно создана: \(newCard.title)")
            } catch {
                print("❌ Ошибка создания карточки: \(error.localizedDescription)")
            }
        } else {
            print("❌ Достигнут лимит карточек")
        }
        
        print()
    }
    
    /// Демонстрирует получение всех карточек
    func exampleGetAllCards() {
        print("=== Пример получения всех карточек ===")
        
        let cards = habitService.getAll()
        print("📊 Всего карточек: \(cards.count)")
        
        for (index, card) in cards.enumerated() {
            print("  \(index + 1). \(card.title) — \(card.daysCount) дней (ID: \(card.id.uuidString.prefix(8)))")
        }
        
        print()
    }
    
    /// Демонстрирует удаление карточки
    func exampleDeleteCard() {
        print("=== Пример удаления карточки ===")
        
        let cards = habitService.getAll()
        
        if let firstCard = cards.first {
            print("🗑 Удаляем карточку: \(firstCard.title)")
            
            do {
                try habitService.delete(id: firstCard.id)
                print("✅ Карточка успешно удалена")
            } catch {
                print("❌ Ошибка удаления карточки: \(error.localizedDescription)")
            }
        } else {
            print("ℹ️ Нет карточек для удаления")
        }
        
        print()
    }
    
    /// Демонстрирует проверку лимита карточек
    func exampleCheckLimit() {
        print("=== Пример проверки лимита ===")
        
        let cards = habitService.getAll()
        let canCreate = habitService.canCreateNewCard()
        
        print("📊 Текущее количество карточек: \(cards.count)")
        print("✅ Можно создать новую: \(canCreate ? "Да" : "Нет")")
        
        print()
    }
    
    /// Демонстрирует валидацию названия привычки
    func exampleValidation() {
        print("=== Пример валидации ===")
        
        // Попытка создать карточку с слишком длинным названием
        let longTitleCard = HabitCard(
            title: "Это очень длинное название привычки которое превышает лимит",
            startDate: Date(),
            daysCount: 0,
            colorID: 2
        )
        
        do {
            try habitService.create(card: longTitleCard)
            print("✅ Карточка создана")
        } catch HabitServiceError.titleTooLong(let maxLength) {
            print("❌ Название слишком длинное. Максимум символов: \(maxLength)")
        } catch {
            print("❌ Другая ошибка: \(error.localizedDescription)")
        }
        
        print()
    }
    
    /// Демонстрирует создание карточек до достижения лимита
    func exampleLimitReached() {
        print("=== Пример достижения лимита ===")
        
        // Пытаемся создать карточки до достижения лимита
        let cardTitles = ["Курение", "Сладости", "Соцсети"]
        
        for title in cardTitles {
            if habitService.canCreateNewCard() {
                let card = HabitCard(
                    title: title,
                    startDate: Date(),
                    daysCount: 0,
                    colorID: Int.random(in: 1...5)
                )
                
                do {
                    try habitService.create(card: card)
                    print("✅ Создана карточка: \(title)")
                } catch HabitServiceError.limitExceeded(let currentCount, let maxLimit) {
                    print("❌ Лимит достигнут! Текущее: \(currentCount), максимум: \(maxLimit)")
                    break
                } catch {
                    print("❌ Ошибка: \(error.localizedDescription)")
                    break
                }
            } else {
                print("❌ Лимит уже достигнут, нельзя создать: \(title)")
                break
            }
        }
        
        print()
    }
    
    /// Запускает все примеры последовательно
    func runAllExamples() {
        print("🚀 Запуск всех примеров использования бизнес-логики\n")
        
        exampleGetAllCards()
        exampleCheckLimit()
        exampleCreateCard()
        exampleGetAllCards()
        exampleValidation()
        exampleLimitReached()
        exampleGetAllCards()
        exampleDeleteCard()
        exampleGetAllCards()
        
        print("✅ Все примеры выполнены")
    }
}
