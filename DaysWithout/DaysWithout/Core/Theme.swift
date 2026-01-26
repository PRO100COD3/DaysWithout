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
    
    /// Цвет заголовка на карточках
    static let cardTextHeaderColor = Color(red: 242/255, green: 244/255, blue: 242/255)
    
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
    
    /// Отступ от краев экрана
    static let screenPadding: CGFloat = 23
    
    /// Отступ кнопкии от краев экрана
    static let buttonPadding: CGFloat = 24
    
    // MARK: - Corner Radius
    
    /// Радиус скругления карточки (по Figma)
    static let cardCornerRadius: CGFloat = 24
    
    // MARK: - Sizes
    
    /// Размер кнопки "Добавить"
    static let addButtonSize: CGFloat = 60
    
    /// Размер прогресс-ринга на карточке
    static let progressRingSize: CGFloat = 127
    
    // MARK: - Animation
    
    /// Длительность анимации нажатия
    static let pressAnimationDuration: TimeInterval = 0.15
    
    /// Тип анимации нажатия
    static let pressAnimationType: Animation = .easeOut(duration: pressAnimationDuration)
    
    // MARK: - Shadow
    
    /// Цвет тени карточки
    static let cardShadowColor = Color.black.opacity(0.15)
    
    /// Радиус размытия тени карточки
    static let cardShadowRadius: CGFloat = 8
    
    /// Горизонтальное смещение тени карточки
    static let cardShadowX: CGFloat = 0
    
    /// Вертикальное смещение тени карточки
    static let cardShadowY: CGFloat = 2
    
    // MARK: - Button Shadow
    
    /// Цвет внешней тени кнопки
    static let buttonDropShadowColor = Color.black.opacity(0.2)
    
    /// Радиус размытия внешней тени кнопки
    static let buttonDropShadowRadius: CGFloat = 16
    
    /// Горизонтальное смещение внешней тени кнопки
    static let buttonDropShadowX: CGFloat = 0
    
    /// Вертикальное смещение внешней тени кнопки
    static let buttonDropShadowY: CGFloat = 6
    
    /// Spread внешней тени кнопки (эмулируется через увеличение радиуса)
    static let buttonDropShadowSpread: CGFloat = 38
    
    /// Цвет внутренней тени кнопки
    static let buttonInnerShadowColor = Color.white.opacity(0.25)
    
    /// Радиус размытия внутренней тени кнопки
    static let buttonInnerShadowRadius: CGFloat = 3
    
    /// Горизонтальное смещение внутренней тени кнопки
    static let buttonInnerShadowX: CGFloat = 1
    
    /// Вертикальное смещение внутренней тени кнопки
    static let buttonInnerShadowY: CGFloat = 1
    
    // MARK: - Typography
    
    /// Название шрифта заголовков
    static let headingFontName = "Onest"
    
    /// Название шрифта карточек
    static let cardFontName = "Inter"
    
    /// Размер шрифта заголовка главного экрана
    static let mainHeadingFontSize: CGFloat = 20
    
    /// Размер шрифта заголовка empty state
    static let emptyStateHeadingFontSize: CGFloat = 18
    
    /// Размер шрифта описания empty state
    static let emptyStateDescriptionFontSize: CGFloat = 14
    
    /// Размер шрифта названия карточки
    static let cardTitleFontSize: CGFloat = 14
    
    /// Размер шрифта количества дней
    static let cardDaysCountFontSize: CGFloat = 36
    
    /// Размер шрифта подписи "дней" и таймера
    static let cardSmallTextFontSize: CGFloat = 12
    
    /// Размер шрифта иконки кнопки "Добавить"
    static let addButtonIconFontSize: CGFloat = 30
    
    // MARK: - Main View Spacing
    
    /// Отступ заголовка сверху
    static let headerTopPadding: CGFloat = 8
    
    /// Отступ заголовка снизу
    static let headerBottomPadding: CGFloat = 12
    
    /// Отступ разделителя снизу
    static let dividerBottomPadding: CGFloat = 20
    
    /// Отступ между элементами в empty state
    static let emptyStateSpacing: CGFloat = 14
    
    /// Отступ empty state сверху
    static let emptyStateTopPadding: CGFloat = 34
    
    /// Отступ между колонками в grid карточек
    static let gridColumnSpacing: CGFloat = 12
    
    /// Отступ между строками в grid карточек
    static let gridRowSpacing: CGFloat = 20
    
    /// Отступ grid сверху
    static let gridTopPadding: CGFloat = 0
    
    // MARK: - Card Spacing
    
    /// Отступ названия карточки снизу
    static let cardTitleBottomPadding: CGFloat = 12
    
    /// Отступ прогресс-ринга снизу
    static let cardProgressRingBottomPadding: CGFloat = 14
    
    /// Отступ контента карточки сверху
    static let cardContentTopPadding: CGFloat = 12
    
    /// Отступ контента карточки снизу
    static let cardContentBottomPadding: CGFloat = 15
    
    /// Высота карточки
    static let cardHeight: CGFloat = 216
    
    // MARK: - Progress Ring
    
    /// Толщина линии прогресс-ринга
    static let progressRingLineWidth: CGFloat = 8
    
    /// Прозрачность фонового круга прогресс-ринга
    static let progressRingBackgroundOpacity: Double = 0.4
    
    // MARK: - Press Animation
    
    /// Масштаб при нажатии на карточку
    static let cardPressScale: CGFloat = 0.95
    
    /// Прозрачность при нажатии на карточку
    static let cardPressOpacity: Double = 0.8
    
    /// Масштаб при нажатии на кнопку
    static let buttonPressScale: CGFloat = 0.9
    
    /// Прозрачность при нажатии на кнопку
    static let buttonPressOpacity: Double = 0.8
    
    /// Цвет иконки кнопки "Добавить"
    static let addButtonIconColor = Color.white
    
    // MARK: - Inner Shadow Gradient
    
    /// Коэффициент начального радиуса внутренней тени кнопки (относительно размера кнопки)
    static let buttonInnerShadowStartRadiusMultiplier: Double = 0.3
    
    /// Коэффициент конечного радиуса внутренней тени кнопки (относительно размера кнопки)
    static let buttonInnerShadowEndRadiusMultiplier: Double = 0.6
}
