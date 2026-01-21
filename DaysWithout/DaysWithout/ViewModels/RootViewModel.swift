//
//  RootViewModel.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import Foundation
import Combine

/// ViewModel корневого экрана.
/// Связывает Model с View, не содержит UI-кода.
@MainActor
final class RootViewModel: ObservableObject {
    
    // MARK: - Published Properties
    // Публикуемые свойства для привязки к View будут добавлены здесь
    
    // MARK: - Private Properties
    
    private var model: RootModel
    
    // MARK: - Initialization
    
    nonisolated init(model: RootModel = RootModel()) {
        self.model = model
    }
    
    // MARK: - Public Methods
    // Методы для взаимодействия с View будут добавлены здесь
}
