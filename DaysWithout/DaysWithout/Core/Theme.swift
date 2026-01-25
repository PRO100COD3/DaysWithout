//
//  Theme.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Тема приложения с цветами и визуальными параметрами
/// Все значения соответствуют дизайну Figma
enum Theme {
    
    // MARK: - Colors
    
    /// Цвета карточек по colorID
    /// Соответствуют цветам из Figma
    /// Градиент от светлого (top) к темному (bottom)
    static func cardColor(for colorID: Int) -> (top: Color, bottom: Color) {
        switch colorID {
        case 1: // Зеленый
            return (Color(red: 152/255, green: 232/255, blue: 89/255), Color(red: 107/255, green: 201/255, blue: 33/255))
        case 2: // Синий
            return (Color(red: 143/255, green: 213/255, blue: 255/255), Color(red: 63/255, green: 167/255, blue: 232/255))
        case 3: // Розовый/Магента
            return (Color(red: 255/255, green: 131/255, blue: 191/255), Color(red: 230/255, green: 103/255, blue: 160/255))
        case 4: // Фиолетовый
            return (Color(red: 201/255, green: 184/255, blue: 255/255), Color(red: 139/255, green: 110/255, blue: 234/255))
        case 5: // Оранжевый
            return (Color(red: 250/255, green: 194/255, blue: 106/255), Color(red: 246/255, green: 140/255, blue: 62/255))
        case 6: // Красный/Коралловый
            return (Color(red: 255/255, green: 156/255, blue: 156/255), Color(red: 231/255, green: 84/255, blue: 84/255))
        default:
            // По умолчанию зеленый
            return (Color(red: 152/255, green: 232/255, blue: 89/255), Color(red: 107/255, green: 201/255, blue: 33/255))
        }
    }
    
    /// Цвет кнопки "Добавить"
    static let addButtonColor = Color(red: 94/255, green: 201/255, blue: 106/255)
    
    /// Цвет текста на карточках
    static let cardTextColor = Color(red: 242/255, green: 244/255, blue: 242/255)
    
    /// Цвет круга на карточках
    static let cardCircleColor = Color.white
    
    /// Цвет заголовка на главном экране
    static let mainHeadingColor = Color(red: 46/255, green: 46/255, blue: 46/255)
    
    /// Цвет описания на главном экране
    static let mainDescriptionColor = Color(red: 122/255, green: 122/255, blue: 122/255)
    
    /// Цвет фона экрана
    static let backgroundColor = [Color(red: 1, green: 1, blue: 1), Color(red: 237/255, green: 241/255, blue: 246/255)]
    
    /// Цвет фона экрана
    static let DeviderColor = Color(red: 230/255, green: 232/255, blue: 235/255)
    // MARK: - Spacing
    
    /// Отступы между карточками
    static let cardSpacing: CGFloat = 16
    
    /// Внутренние отступы карточки (по Figma)
    static let cardPadding: CGFloat = 20
    
    /// Отступ от краев экрана
    static let screenPadding: CGFloat = 23
    
    /// Отступ кнопкии от краев экрана
    static let buttonPadding: CGFloat = 24
    
    // MARK: - Corner Radius
    
    /// Радиус скругления карточки (по Figma)
    static let cardCornerRadius: CGFloat = 24
    
    /// Радиус кнопки "Добавить"
    static let addButtonCornerRadius: CGFloat = 28
    
    // MARK: - Sizes
    
    /// Размер кнопки "Добавить"
    static let addButtonSize: CGFloat = 60
    
    /// Размер прогресс-ринга на карточке
    static let progressRingSize: CGFloat = 120
    
    // MARK: - Animation
    
    /// Длительность анимации нажатия
    static let pressAnimationDuration: TimeInterval = 0.15
    
    /// Тип анимации нажатия
    static let pressAnimationType: Animation = .easeOut(duration: pressAnimationDuration)
}
