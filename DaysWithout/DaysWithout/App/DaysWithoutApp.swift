//
//  DaysWithoutApp.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Точка входа приложения
@main
struct DaysWithoutApp: App {
    
    // MARK: - Properties
    
    private let habitService: HabitServiceProtocol
    private let userStatusProvider: UserStatusProvider
    private let timerService: TimerServiceProtocol
    
    // MARK: - Initialization
    
    init() {
        // Инициализируем зависимости
        let storageService = UserDefaultsStorageService()
        let statusProvider = DefaultUserStatusProvider()
        
        let habitService = HabitService(
            storageService: storageService,
            userStatusProvider: statusProvider
        )
        
        self.habitService = habitService
        self.userStatusProvider = statusProvider
        self.timerService = TimerService(habitService: habitService)
    }
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MainView(
                habitService: habitService,
                userStatusProvider: userStatusProvider,
                timerService: timerService
            )
        }
    }
}
