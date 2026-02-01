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
        case 7: // Бирюзовый
            return (Color(red: 127/255, green: 238/255, blue: 210/255), Color(red: 53/255, green: 192/255, blue: 164/255))
        case 8: // Хаки
            return (Color(red: 188/255, green: 224/255, blue: 148/255), Color(red: 127/255, green: 170/255, blue: 90/255))
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
    
    /// Длительность анимации нажатия (одна фаза: нажатие или возврат)
    /// Полный цикл (нажатие + возврат) = 180мс
    static let pressAnimationDuration: TimeInterval = 0.09
    
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
    
    // MARK: - AddHabit Modal
    
    /// Горизонтальный отступ модального окна AddHabit от краёв экрана (MainView)
    static let addHabitModalHorizontalMargin: CGFloat = 56
    /// Радиус размытия фона главного экрана при открытии модалки AddHabit (0 = без размытия)
    static let addHabitBackdropBlurRadius: CGFloat = 8
    /// Горизонтальный отступ контента модального окна AddHabit
    static let addHabitContentHorizontalPadding: CGFloat = 24
    /// Вертикальный отступ контента модального окна AddHabit (top/bottom)
    static let addHabitContentVerticalPadding: CGFloat = 24
    /// Отступ заголовка от поля ввода
    static let addHabitTitleToInputSpacing: CGFloat = 12
    /// Внутренний отступ блока поля ввода (между элементами)
    static let addHabitInputInternalSpacing: CGFloat = 8
    /// Отступ поля ввода от блока выбора цвета
    static let addHabitInputToColorSpacing: CGFloat = 16
    /// Горизонтальный отступ блока выбора цвета
    static let addHabitColorSectionHorizontalPadding: CGFloat = 27
    /// Отступ блока цветов от кнопок
    static let addHabitColorToButtonsSpacing: CGFloat = 24
    /// Отступ между элементами в заголовке AddHabit
    static let addHabitHeaderSpacing: CGFloat = 12
    /// Радиус скругления модального окна AddHabit
    static let addHabitModalCornerRadius: CGFloat = 25
    /// Прозрачность фона модального окна AddHabit
    static let addHabitModalBackgroundOpacity: Double = 0.85
    /// Цвет рамки модального окна AddHabit
    static let addHabitModalBorderColor = Color.black.opacity(0.2)
    /// Тень модального окна AddHabit: цвет
    static let addHabitModalShadowColor = Color.black.opacity(0.12)
    /// Тень модального окна AddHabit: радиус
    static let addHabitModalShadowRadius: CGFloat = 25
    /// Тень модального окна AddHabit: смещение Y
    static let addHabitModalShadowY: CGFloat = 10
    /// Внутренняя тень модального окна: цвет
    static let addHabitModalInnerShadowColor = Color.white.opacity(0.05)
    /// Внутренняя тень модального окна: смещение Y
    static let addHabitModalInnerShadowOffsetY: CGFloat = 4
    /// Внутренняя тень модального окна: размытие
    static let addHabitModalInnerShadowBlur: CGFloat = 20
    /// Отступ алерта по горизонтали
    static let addHabitAlertHorizontalPadding: CGFloat = 24
    
    /// Цвет заголовка AddHabit
    static let addHabitHeadingColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    /// Цвет счётчика карточек AddHabit
    static let addHabitCounterColor = Color(red: 43/255, green: 43/255, blue: 43/255).opacity(0.6)
    /// Размер шрифта заголовка и счётчика AddHabit
    static let addHabitHeaderFontSize: CGFloat = 16
    
    /// Placeholder поля названия
    static let addHabitTitlePlaceholder = "Название"
    /// Цвет текста поля ввода (placeholder/ввод)
    static let addHabitInputTextColor = Color(red: 156/255, green: 163/255, blue: 175/255)
    /// Размер шрифта поля ввода
    static let addHabitInputFontSize: CGFloat = 14
    /// Внутренние отступы поля ввода (horizontal, vertical)
    static let addHabitInputPaddingH: CGFloat = 16
    static let addHabitInputPaddingV: CGFloat = 12
    /// Цвет фона поля ввода
    static let addHabitInputBackgroundColor = Color(red: 247/255, green: 247/255, blue: 247/255)
    /// Радиус скругления поля ввода
    static let addHabitInputCornerRadius: CGFloat = 10
    /// Цвет рамки поля ввода (норма)
    static let addHabitInputBorderColorNormal = Color(red: 230/255, green: 230/255, blue: 230/255)
    /// Цвет рамки поля ввода (ошибка)
    static let addHabitInputBorderColorError = Color(red: 231/255, green: 84/255, blue: 84/255)
    /// Тень поля ввода: цвет, радиус, Y
    static let addHabitInputShadowColor = Color.black.opacity(0.12)
    static let addHabitInputShadowRadius: CGFloat = 12
    static let addHabitInputShadowY: CGFloat = 4
    
    /// Отступ между элементами в блоке выбора цвета
    static let addHabitColorSectionSpacing: CGFloat = 16
    /// Размер кружка цвета
    static let addHabitColorCircleSize: CGFloat = 32
    /// Размер обводки выбранного цвета (внешний frame)
    static let addHabitColorCircleSelectedSize: CGFloat = 38
    /// Радиус скругления обводки выбранного цвета
    static let addHabitColorCircleSelectedCornerRadius: CGFloat = 19
    /// Цвета обводки выбранного цвета (градиент)
    static let addHabitColorCircleSelectedStrokeColors = [Color(red: 255/255, green: 255/255, blue: 255/255), Color(red: 240/255, green: 240/255, blue: 240/255)]
    
    /// Отступ между кнопками ОТМЕНА/СОЗДАТЬ
    static let addHabitButtonsSpacing: CGFloat = 12
    /// Высота кнопок ОТМЕНА/СОЗДАТЬ
    static let addHabitButtonHeight: CGFloat = 44
    /// Радиус скругления кнопок
    static let addHabitButtonCornerRadius: CGFloat = 12
    /// Шрифт кнопок
    static let addHabitButtonFontSize: CGFloat = 14
    /// Цвет текста кнопки ОТМЕНА
    static let addHabitCancelButtonTextColor = Color(red: 110/255, green: 110/255, blue: 110/255)
    /// Цвет фона кнопки ОТМЕНА
    static let addHabitCancelButtonBackgroundColor = Color(red: 242/255, green: 242/255, blue: 242/255)
    /// Цвет рамки кнопки ОТМЕНА
    static let addHabitCancelButtonBorderColor = Color(red: 224/255, green: 224/255, blue: 224/255)
    /// Цвет текста кнопки СОЗДАТЬ
    static let addHabitCreateButtonTextColor = Color(red: 58/255, green: 111/255, blue: 68/255)
    /// Цвет фона кнопки СОЗДАТЬ
    static let addHabitCreateButtonBackgroundColor = Color(red: 216/255, green: 241/255, blue: 207/255)
    /// Цвет рамки кнопки СОЗДАТЬ
    static let addHabitCreateButtonBorderColor = Color(red: 212/255, green: 232/255, blue: 217/255).opacity(0.9)
    /// Тень кнопок: цвет, радиус, Y
    static let addHabitButtonShadowRadius: CGFloat = 12
    static let addHabitButtonShadowY: CGFloat = 4
    
    /// Тексты алертов AddHabit (для отображения в UI)
    static let addHabitAlertEnterTitle = "Введите название"
    static func addHabitAlertMaxCharacters(_ maxLength: Int) -> String {
        "Максимальное кол-во символов - \(maxLength)"
    }
    
    /// Длительность показа алерта (сек)
    static let addHabitAlertDisplayDuration: TimeInterval = 3
    /// Параметры анимации алерта
    static let addHabitAlertAnimationResponse: Double = 0.3
    static let addHabitAlertAnimationDamping: Double = 0.7
    /// Анимация появления/исчезновения алерта (централизовано)
    static var addHabitAlertAnimation: Animation {
        .spring(response: addHabitAlertAnimationResponse, dampingFraction: addHabitAlertAnimationDamping)
    }
    
    // MARK: - CharacterLimitAlertView
    
    /// Отступ алерта по горизонтали
    static let characterLimitAlertHorizontalPadding: CGFloat = 25
    /// Высота алерта
    static let characterLimitAlertHeight: CGFloat = 58
    /// Радиус скругления алерта
    static let characterLimitAlertCornerRadius: CGFloat = 20
    /// Размер шрифта алерта
    static let characterLimitAlertFontSize: CGFloat = 16
    /// Цвета градиента фона алерта (светлый, тёмный)
    static let characterLimitAlertGradientTop = Color(red: 1.0, green: 0.612, blue: 0.612)
    static let characterLimitAlertGradientBottom = Color(red: 0.906, green: 0.329, blue: 0.329)
    
    /// Цвет красной кнопки (диалоги удаления/рестарта)
    static let redButton = Color(red: 231/255, green: 84/255, blue: 84/255)
}
