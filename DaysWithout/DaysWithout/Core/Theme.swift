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
    /// Отступ между блоками во VStack главного экрана (0 = без отступа)
    static let mainContentStackSpacing: CGFloat = 0
    /// zIndex оверлея модального окна AddHabit
    static let mainModalZIndex: Double = 1000
    /// Количество колонок в сетке карточек
    static let mainGridColumnCount: Int = 2

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
    /// Ширина карточки в Preview (для корректного отображения)
    static let cardPreviewWidth: CGFloat = 180
    
    // MARK: - Progress Ring
    
    /// Толщина линии прогресс-ринга
    static let progressRingLineWidth: CGFloat = 8
    
    /// Прозрачность фонового круга прогресс-ринга
    static let progressRingBackgroundOpacity: Double = 0.4
    /// Поворот прогресс-ринга в градусах (старт сверху)
    static let progressRingRotationDegrees: Double = -90

    // MARK: - Card Content

    /// Отступ между элементами во VStack контента карточки (0 = без отступа)
    static let cardContentStackSpacing: CGFloat = 0
    /// Масштаб карточки в покое
    static let cardIdleScale: CGFloat = 1.0
    /// Прозрачность карточки в покое
    static let cardIdleOpacity: Double = 1.0
    /// Лимит строк в названии карточки
    static let cardTitleLineLimit: Int = 1

    // MARK: - Press Animation
    
    /// Масштаб при нажатии на карточку
    static let cardPressScale: CGFloat = 0.95
    
    /// Прозрачность при нажатии на карточку
    static let cardPressOpacity: Double = 0.8
    
    /// Масштаб при нажатии на кнопку
    static let buttonPressScale: CGFloat = 0.9
    
    /// Прозрачность при нажатии на кнопку
    static let buttonPressOpacity: Double = 0.8

    /// Масштаб при нажатии (универсальный модификатор pressAnimation)
    static let pressModifierScale: CGFloat = 0.95
    /// Прозрачность при нажатии (универсальный модификатор pressAnimation)
    static let pressModifierOpacity: Double = 0.9
    
    /// Цвет иконки кнопки "Добавить"
    static let addButtonIconColor = Color.white
    
    // MARK: - Inner Shadow Gradient
    
    /// Коэффициент начального радиуса внутренней тени кнопки (относительно размера кнопки)
    static let buttonInnerShadowStartRadiusMultiplier: Double = 0.3
    
    /// Коэффициент конечного радиуса внутренней тени кнопки (относительно размера кнопки)
    static let buttonInnerShadowEndRadiusMultiplier: Double = 0.6
    
    // MARK: - AddHabit Modal
    
    /// Отступ между блоками во VStack контента AddHabit (0 = без отступа)
    static let addHabitContentStackSpacing: CGFloat = 0
    /// Толщина обводки модального окна AddHabit
    static let addHabitModalStrokeLineWidth: CGFloat = 1
    /// Толщина обводки поля ввода AddHabit
    static let addHabitInputBorderLineWidth: CGFloat = 1
    /// Толщина обводки кнопок ОТМЕНА/СОЗДАТЬ
    static let addHabitButtonStrokeLineWidth: CGFloat = 1
    /// Количество колонок в сетке выбора цвета (4 колонки × 2 ряда = 8 цветов)
    static let addHabitColorGridColumnCount: Int = 4
    /// Количество доступных цветов карточки
    static let addHabitColorCount: Int = 8
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

    // MARK: - Story

    static let storyHeaderChevronFontSize: CGFloat = 14
    static let storyHeaderButtonSize: CGFloat = 24
    static let storyHeaderTitleFontSize: CGFloat = 20
    static let storyHeaderCoinsButtonSize: CGFloat = 36
    static let storyHeaderHorizontalPadding: CGFloat = 16
    static let storyHeaderTopPadding: CGFloat = 7
    static let storyPlaceholderFontSize: CGFloat = 18
    static let storyPlaceholderTopPadding: CGFloat = 37
    static let storyHistoryListSpacing: CGFloat = 16
    static let storyHistoryListTopPadding: CGFloat = 44
    static let storyHistoryCellInternalSpacing: CGFloat = 14
    static let storyHistoryCellDaysFontSize: CGFloat = 18
    static let storyHistoryCellReasonFontSize: CGFloat = 18
    static let storyHistoryCellDateFontSize: CGFloat = 16
    static let storyHistoryCellGreen = Color(red: 72/255, green: 153/255, blue: 39/255)
    static let storyHistoryCellReasonColor = Color(red: 154/255, green: 154/255, blue: 154/255)
    static let storyHistoryCellDateColor = Color(red: 85/255, green: 85/255, blue: 85/255)
    static let storyHistoryCellHorizontalPadding: CGFloat = 20
    static let storyHistoryCellVerticalPadding: CGFloat = 24
    static let storyHistoryCellBackgroundOpacity: Double = 0.95
    static let storyHistoryCellCornerRadius: CGFloat = 24
    static let storyHistoryCellStrokeOpacity: Double = 0.08
    static let storyHistoryCellShadowOpacity: Double = 0.06
    static let storyHistoryCellShadowRadius: CGFloat = 36
    static let storyHistoryCellShadowY: CGFloat = 8
    /// Отступ между блоками во VStack StoryView (0 = без отступа)
    static let storyContentStackSpacing: CGFloat = 0
    /// Цвет заголовка (название карточки) в хедере Story
    static let storyHeaderTitleColor = Color.black
    /// Толщина обводки ячейки истории
    static let storyHistoryCellStrokeLineWidth: CGFloat = 1

    // MARK: - Support

    static let supportTitleFontSize: CGFloat = 20
    static let supportTitleColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    static let supportTitleTopPadding: CGFloat = 24
    static let supportContentHorizontalPadding: CGFloat = 24
    static let supportMessageFontSize: CGFloat = 16
    static let supportMessageColor = Color(red: 109/255, green: 109/255, blue: 109/255)
    static let supportMessageTopPadding: CGFloat = 12
    static let supportButtonFontSize: CGFloat = 14
    static let supportButtonTextColor = Color(red: 173/255, green: 133/255, blue: 17/255)
    static let supportButtonVerticalPadding: CGFloat = 12
    static let supportButtonBackgroundColor = Color(red: 255/255, green: 211/255, blue: 34/255).opacity(0.8)
    static let supportButtonCornerRadius: CGFloat = 14
    static let supportButtonStrokeColor = Color(red: 248/255, green: 224/255, blue: 130/255)
    static let supportContentPadding: CGFloat = 24
    static let supportButtonShadowRadius: CGFloat = 8
    static let supportButtonShadowY: CGFloat = 4
    static let supportCloseButtonFontSize: CGFloat = 16
    static let supportCloseButtonSize: CGFloat = 36
    static let supportCloseButtonPadding: CGFloat = 10
    /// Отступ между блоками во VStack SupportView (0 = без отступа)
    static let supportContentStackSpacing: CGFloat = 0
    /// Толщина обводки кнопки и модалки Support
    static let supportStrokeLineWidth: CGFloat = 1

    // MARK: - SelectPurchases

    static let selectPurchasesHeaderTopPadding: CGFloat = 24
    static let selectPurchasesOptionsTopPadding: CGFloat = 15
    static let selectPurchasesHeaderSpacing: CGFloat = 12
    static let selectPurchasesTitleFontSize: CGFloat = 20
    static let selectPurchasesDescriptionFontSize: CGFloat = 16
    static let selectPurchasesDescriptionColor = Color(red: 109/255, green: 109/255, blue: 109/255)
    static let selectPurchasesOptionsSpacing: CGFloat = 12
    static let selectPurchasesOptionPriceFontSize: CGFloat = 20
    static let selectPurchasesOptionPeriodFontSize: CGFloat = 16
    static let selectPurchasesOptionTextColor = Color(red: 43/255, green: 43/255, blue: 43/255)
    static let selectPurchasesOptionSelectedSubtextColor = Color(red: 232/255, green: 255/255, blue: 232/255)
    static let selectPurchasesOptionSelectedGradientTop = Color(red: 133/255, green: 239/255, blue: 163/255)
    static let selectPurchasesOptionSelectedGradientBottom = Color(red: 91/255, green: 203/255, blue: 121/255)
    static let selectPurchasesOptionPadding: CGFloat = 16
    static let selectPurchasesOptionCornerRadius: CGFloat = 18
    static let selectPurchasesOptionShadowRadius: CGFloat = 12
    static let selectPurchasesOptionShadowY: CGFloat = 2
    /// Прозрачность текста периода у невыбранной опции
    static let selectPurchasesOptionUnselectedOpacity: Double = 0.6
    static let selectPurchasesSubscribeButtonFontSize: CGFloat = 14
    static let selectPurchasesSubscribeButtonStrokeCornerRadius: CGFloat = 14
    static let selectPurchasesSubscribeButtonShadowRadius: CGFloat = 8
    static let selectPurchasesSubscribeButtonShadowY: CGFloat = 4
    static let selectPurchasesCloseButtonFontSize: CGFloat = 18
    static let selectPurchasesCloseButtonSize: CGFloat = 36
    static let selectPurchasesCloseButtonPadding: CGFloat = 10
    static let selectPurchasesBottomVerticalPadding: CGFloat = 24
    /// Отступ между блоками во VStack SelectPurchasesView (0 = без отступа)
    static let selectPurchasesContentStackSpacing: CGFloat = 0
    /// Цвет текста цены у выбранной опции
    static let selectPurchasesOptionSelectedTextColor = Color.white
    /// Фон невыбранной опции
    static let selectPurchasesOptionUnselectedBackground = Color.white
    /// Толщина обводки модалки и кнопки подписки
    static let selectPurchasesStrokeLineWidth: CGFloat = 1
    /// Прозрачность при скрытии контента (показан Success)
    static let selectPurchasesHiddenOpacity: Double = 0
    /// Прозрачность при отображении контента
    static let selectPurchasesVisibleOpacity: Double = 1

    // MARK: - SuccessPurchases

    static let successTitleFontSize: CGFloat = 20
    static let successTitleTopPadding: CGFloat = 24
    static let successMessageFontSize: CGFloat = 16
    static let successMessageTopPadding: CGFloat = 12
    static let successMessageHorizontalPadding: CGFloat = 24
    static let successButtonFontSize: CGFloat = 14
    static let successButtonHeight: CGFloat = 50
    static let successButtonCornerRadius: CGFloat = 14
    static let successContentVerticalPadding: CGFloat = 24
    static let successButtonShadowRadius: CGFloat = 8
    static let successButtonShadowY: CGFloat = 4
    static let successModalStrokeCornerRadius: CGFloat = 25
    static let successModalShadowRadius: CGFloat = 25
    static let successModalShadowY: CGFloat = 10
    static let successCloseButtonFontSize: CGFloat = 16
    static let successCloseButtonSize: CGFloat = 36
    static let successCloseButtonPadding: CGFloat = 10
    /// Отступ между блоками во VStack SuccessPurchasesView (0 = без отступа)
    static let successContentStackSpacing: CGFloat = 0
    /// Толщина обводки модалки Success
    static let successModalStrokeLineWidth: CGFloat = 1

    // MARK: - Date

    static let dateContentHorizontalPadding: CGFloat = 23
    static let dateHeaderChevronFontSize: CGFloat = 14
    static let dateHeaderBackButtonSize: CGFloat = 24
    static let dateHeaderTitleFontSize: CGFloat = 20
    static let dateHeaderPlaceholderSize: CGSize = CGSize(width: 34, height: 36)
    static let dateHeaderHorizontalPadding: CGFloat = 16
    static let dateCalendarCardSpacing: CGFloat = 13
    static let dateCalendarNavButtonFontSize: CGFloat = 16
    static let dateCalendarNavGreen = Color(red: 72/255, green: 153/255, blue: 79/255)
    static let dateCalendarNavButtonPadding: CGFloat = 6
    static let dateCalendarMonthFontSize: CGFloat = 20
    static let dateCalendarWeekdayFontSize: CGFloat = 14
    static let dateCalendarWeekdayColor = Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.3)
    static let dateCalendarGridItemSpacing: CGFloat = 8
    static let dateCalendarGridRowSpacing: CGFloat = 7
    /// Количество колонок в сетке календаря (дней в неделе)
    static let dateCalendarWeekdayColumnCount: Int = 7
    static let dateCalendarDayFontSize: CGFloat = 18
    static let dateCalendarDayCellSize: CGFloat = 44
    static let dateCalendarDaySelectedBackground = Color(red: 217/255, green: 248/255, blue: 201/255)
    static let dateCalendarEmptyCellSize: CGFloat = 36
    static let dateCalendarCardTopPadding: CGFloat = 24
    static let dateCalendarCardHorizontalPadding: CGFloat = 20
    static let dateCalendarCardBackgroundOpacity: Double = 0.85
    static let dateCalendarCardCornerRadius: CGFloat = 25
    static let dateCalendarCardStrokeOpacity: Double = 0.08
    static let dateCalendarCardStrokeLineWidth: CGFloat = 1
    static let dateCalendarCardShadowRadius: CGFloat = 25
    static let dateCalendarCardShadowY: CGFloat = 10
    static let dateCalendarCardButtonShadowRadius: CGFloat = 8
    static let dateCalendarCardButtonShadowY: CGFloat = 4
    static let dateTimeWheelRowHeight: CGFloat = 34
    static let dateTimeWheelVisibleHeight: CGFloat = 200
    static let dateTimeWheelTopPadding: CGFloat = 24
    static let dateTimeCardButtonTopPadding: CGFloat = 16
    static let dateCreateButtonFontSize: CGFloat = 14
    static let dateCreateButtonTextColor = Color(red: 72/255, green: 153/255, blue: 79/255)
    static let dateCreateButtonVerticalPadding: CGFloat = 14
    static let dateCreateButtonBackgroundColor = Color(red: 217/255, green: 248/255, blue: 201/255)
    static let dateCreateButtonCornerRadius: CGFloat = 12
    static let dateCreateButtonTopPadding: CGFloat = 24
    static let dateCreateButtonBottomPadding: CGFloat = 24
    static let dateTimePickerRowHeight: CGFloat = 34
    static let dateTimePickerComponentWidth: CGFloat = 50
    /// Количество компонентов пикера (часы + минуты)
    static let dateTimePickerComponentCount: Int = 2
    /// Количество часов в сутках для пикера
    static let dateTimePickerHoursCount: Int = 24
    /// Количество минут в часе для пикера
    static let dateTimePickerMinutesCount: Int = 60
    /// Отступ между блоками во VStack на экране Date (0 = без отступа)
    static let dateContentStackSpacing: CGFloat = 0

    // MARK: - Timer

    static let timerGradientTop = Color(red: 127/255, green: 238/255, blue: 210/255)
    static let timerGradientBottom = Color(red: 53/255, green: 192/255, blue: 164/255)
    static let timerCloseCircleSize: CGFloat = 32
    static let timerCloseCircleColor = Color.white
    static let timerCloseCircleOpacity: Double = 0.18
    static let timerCloseButtonFontSize: CGFloat = 18
    static let timerCloseButtonFrameSize: CGFloat = 44
    static let timerCloseButtonTopPadding: CGFloat = 3
    static let timerCloseButtonTrailingPadding: CGFloat = 14
    static let timerTextFieldFontSize: CGFloat = 24
    static let timerTextFieldTopPadding: CGFloat = 46
    static let timerTextFieldHorizontalPadding: CGFloat = 20
    static let timerProgressTopPadding: CGFloat = 53
    static let timerRestartButtonFontSize: CGFloat = 20
    static let timerRestartButtonVerticalPadding: CGFloat = 16
    static let timerRestartButtonCornerRadius: CGFloat = 10
    static let timerRestartButtonBackgroundOpacity: Double = 0.3
    static let timerRestartButtonStrokeOpacity: Double = 0.8
    static let timerRestartButtonWidth: CGFloat = 115
    static let timerRestartButtonHeight: CGFloat = 37
    static let timerRestartButtonTopPadding: CGFloat = 68
    static let timerActionsSpacing: CGFloat = 80
    static let timerActionIconFontSize: CGFloat = 24
    static let timerActionVerticalPadding: CGFloat = 16
    static let timerActionsTopPadding: CGFloat = 57
    static let timerActionsHorizontalPadding: CGFloat = 67
    static let timerOverlayBlurRadius: CGFloat = 8
    static let timerOverlayOpacity: Double = 0.3
    static let timerAlertPadding: CGFloat = 24
    static let timerRestartDialogTopPadding: CGFloat = 238
    static let timerCloseDialogTopPadding: CGFloat = 270
    /// Цвет заливки кнопки РЕСТАРТ (белый полупрозрачный)
    static let timerRestartButtonBackgroundColor = Color(red: 1, green: 1, blue: 1)
    /// Отступ между блоками во VStack TimerView (0 = без отступа)
    static let timerContentStackSpacing: CGFloat = 0
    /// Основной цвет текста и иконок на экране таймера (белый на градиенте)
    static let timerPrimaryTextColor = Color.white
    /// Толщина обводки кнопки РЕСТАРТ
    static let timerRestartButtonStrokeLineWidth: CGFloat = 1

    // MARK: - Common Overlay

    /// Прозрачность затемнённого фона модальных экранов (overlay)
    static let modalOverlayOpacity: Double = 0.3

    // MARK: - CircularProgressView (Timer screen)

    static let circularProgressRingSize: CGFloat = 280
    static let circularProgressRingLineWidth: CGFloat = 14
    static let circularProgressRingBackgroundOpacity: Double = 0.4
    static let circularProgressDaysFontSize: CGFloat = 50
    static let circularProgressDaysWordFontSize: CGFloat = 18
    static let circularProgressDaysWordTopPadding: CGFloat = 4
    static let circularProgressDaysWordOpacity: Double = 0.8
    static let circularProgressTimeFontSize: CGFloat = 24
    static let circularProgressTimeTopPadding: CGFloat = 16
    /// Отступ между элементами во VStack CircularProgressView (0 = без отступа)
    static let circularProgressContentStackSpacing: CGFloat = 0
    /// Цвет текста количества дней и времени в CircularProgressView
    static let circularProgressTextColor = Color.white
    /// Поворот кольца в CircularProgressView (старт сверху)
    static let circularProgressRingRotationDegrees: Double = -90

    // MARK: - Date time wheel lines

    static let dateTimeWheelLineOpacity: Double = 0.12
    static let dateTimeWheelLineHeight: CGFloat = 1

    // MARK: - RestartDialog / ConfirmationDialog

    static let dialogPadding: CGFloat = 24
    static let dialogCornerRadius: CGFloat = 20
    static let dialogGradientTop = Color(red: 0.984, green: 0.984, blue: 0.984)
    static let dialogGradientBottom = Color(red: 0.922, green: 0.922, blue: 0.922)
    static let dialogShadowOpacity: Double = 0.25
    static let dialogShadowRadius: CGFloat = 12
    static let dialogShadowY: CGFloat = 4
    static let dialogHorizontalPadding: CGFloat = 37
    static let dialogTitleFontSize: CGFloat = 20
    static let dialogTitleColor = Color(red: 34/255, green: 34/255, blue: 34/255)
    static let dialogBodyFontSize: CGFloat = 16
    static let dialogBodyColor = Color(red: 85/255, green: 85/255, blue: 85/255)
    static let dialogSpacing: CGFloat = 12
    static let dialogButtonFontSize: CGFloat = 14
    static let dialogButtonHeight: CGFloat = 36
    static let dialogButtonCornerRadius: CGFloat = 10
    static let dialogButtonShadowOpacity: Double = 0.12
    static let dialogButtonShadowRadius: CGFloat = 12
    static let dialogButtonShadowY: CGFloat = 4
    static let dialogCancelButtonTextColor = Color(red: 110/255, green: 110/255, blue: 110/255)
    static let dialogRedButtonTextColor = Color(red: 244/255, green: 244/255, blue: 244/255)
    static let dialogCancelButtonBorderColor = Color(red: 204/255, green: 204/255, blue: 204/255).opacity(0.8)
    static let dialogRedButtonBorderColor = Color(red: 208/255, green: 208/255, blue: 208/255).opacity(0.9)
    static let dialogAnimationDuration: Double = 0.18
    static let dialogPresentedOpacity: Double = 1.0
    static let dialogDismissedOpacity: Double = 0.0
    static let dialogPresentedScale: CGFloat = 1.0
    static let dialogDismissedScale: CGFloat = 0.95

    // MARK: - RestartDialog (specific)

    static let restartDialogTextEditorFontSize: CGFloat = 14
    static let restartDialogInputBackgroundColor = Color(red: 247/255, green: 247/255, blue: 247/255)
    static let restartDialogInputBorderColorNormal = Color(red: 230/255, green: 230/255, blue: 230/255)
    static let restartDialogInputPlaceholderColor = Color(red: 156/255, green: 163/255, blue: 175/255)
    static let restartDialogInputPaddingH: CGFloat = 7
    static let restartDialogInputPaddingV: CGFloat = 7
    static let restartDialogInputPaddingTrailing: CGFloat = 5
    static let restartDialogPlaceholderPaddingH: CGFloat = 12
    static let restartDialogPlaceholderPaddingV: CGFloat = 15
    static let restartDialogTextEditorMinHeight: CGFloat = 48
    static let restartDialogTextEditorMaxHeight: CGFloat = 66
    static let restartDialogHeightAnimationDuration: Double = 0.15
    /// Горизонтальный вычет для расчёта ширины текста (padding left + right)
    static let restartDialogCalculateWidthInset: CGFloat = 19
    /// Вертикальный отступ текста (padding top/bottom при расчёте высоты)
    static let restartDialogCalculateVerticalInset: CGFloat = 14
    /// Доп. отступ снизу при расчёте высоты
    static let restartDialogCalculateBottomInset: CGFloat = 16

    // MARK: - AddHabit color circle stroke

    static let addHabitColorCircleSelectedStrokeWidth: CGFloat = 3
    
    /// Горизонтальный отступ алерта от краёв модального окна AddHabit (отрицательный для выхода за границы)
    static let addHabitAlertHorizontalPaddingAlert: CGFloat = -32

    // MARK: - CharacterLimitAlertView

    static let characterLimitAlertTextColor = Color.white

    // MARK: - Preview (preview backgrounds)

    static let previewOverlayGrayOpacity: Double = 0.5
    static let previewOverlayGreenOpacity: Double = 0.3
    static let previewOverlayLightOpacity: Double = 0.1
    /// Фон Preview для SuccessPurchasesView
    static let previewBackgroundWhite = Color.white
}
