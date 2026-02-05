//
//  SelectPurchasesViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// Опция подписки: цена и период
struct SubscriptionOption: Identifiable {
    let id: String
    let priceRub: Int
    let periodTitle: String
    
    var priceText: String { "\(priceRub) ₽" }
}

/// ViewModel экрана выбора подписки Премиум. Управляет списком опций и выбором; не содержит UI-кода.
@MainActor
final class SelectPurchasesViewModel: ObservableObject {
    
    /// Опции подписки: Месяц, Год, Навсегда
    let options: [SubscriptionOption] = [
        SubscriptionOption(id: "month", priceRub: 79, periodTitle: "Месяц"),
        SubscriptionOption(id: "year", priceRub: 499, periodTitle: "Год"),
        SubscriptionOption(id: "forever", priceRub: 749, periodTitle: "Навсегда")
    ]
    
    /// Индекс выбранной опции (по умолчанию — Месяц)
    @Published var selectedIndex: Int = 0
    
    /// Показан ли экран успешного оформления подписки
    @Published var isSuccessPresented: Bool = false
    
    /// Заголовок экрана
    var title: String { "Премиум" }
    
    /// Описание преимущества
    var descriptionText: String { "Неограниченное число карточек" }
    
    /// Текст кнопки оформления
    var subscribeButtonTitle: String { "ОФОРМИТЬ ПОДПИСКУ" }
    
    /// Выбранная опция
    var selectedOption: SubscriptionOption {
        guard options.indices.contains(selectedIndex) else { return options[0] }
        return options[selectedIndex]
    }
    
    private let onCloseAll: () -> Void
    
    init(onCloseAll: @escaping () -> Void) {
        self.onCloseAll = onCloseAll
    }
    
    /// Выбрать опцию по индексу
    func selectOption(at index: Int) {
        guard options.indices.contains(index) else { return }
        selectedIndex = index
    }
    
    /// Оформить подписку (выбранная опция). Показывает экран успеха.
    func subscribe() {
        _ = selectedOption
        // TODO: интеграция с StoreKit / сервисом покупок
        isSuccessPresented = true
    }
    
    /// Закрыть только экраны подписки, Story остаётся (крестик или «СПАСИБО» на Success, крестик на SelectPurchases)
    func closeAll() {
        onCloseAll()
    }
}
