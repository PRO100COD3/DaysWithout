//
//  MainViewModel.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import Foundation
import Combine

/// ViewModel для главного экрана приложения
/// Связывает бизнес-логику с UI, не содержит UI-кода
@MainActor
final class MainViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Список карточек привычек для отображения
    @Published private(set) var cards: [HabitCard] = []
    
    /// Можно ли создать новую карточку (для отображения кнопки "Добавить")
    @Published private(set) var canCreateCard: Bool = false
    
    /// Статус пользователя (для определения лимитов)
    @Published private(set) var userStatus: UserStatus = .free
    
    /// Максимальное количество карточек для отображения (зависит от статуса пользователя)
    var maxCardsLimit: Int {
        userStatus.maxCardsLimit
    }
    
    /// Карточки для отображения (с учетом лимита статуса пользователя)
    var displayableCards: [HabitCard] {
        Array(cards.prefix(maxCardsLimit))
    }
    
    /// Нужно ли показывать кнопку "Добавить" (проверяет лимит статуса пользователя)
    var shouldShowAddButton: Bool {
        // Кнопка показывается, если количество отображаемых карточек меньше лимита статуса
        displayableCards.count < maxCardsLimit
    }
    
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
        loadData()
    }
    
    // MARK: - Public Methods
    
    /// Загружает данные карточек и обновляет состояние
    func loadData() {
        // Получаем статус пользователя
        userStatus = userStatusProvider.getCurrentStatus()
        
        // Получаем все карточки
        cards = habitService.getAll()
        
        // Проверяем, можно ли создать новую карточку
        canCreateCard = habitService.canCreateNewCard()
    }
}
