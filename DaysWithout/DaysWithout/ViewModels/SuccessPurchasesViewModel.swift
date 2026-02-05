//
//  SuccessPurchasesViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// ViewModel экрана успешного оформления подписки. Управляет закрытием; не содержит UI-кода.
@MainActor
final class SuccessPurchasesViewModel: ObservableObject {
    
    /// Заголовок экрана
    var title: String { "Поздравляем" }
    
    /// Текст сообщения
    var message: String { "Вы успешно оформили подписку" }
    
    /// Текст кнопки
    var buttonTitle: String { "СПАСИБО" }
    
    private let onCloseAll: () -> Void
    
    init(onCloseAll: @escaping () -> Void) {
        self.onCloseAll = onCloseAll
    }
    
    /// Закрыть только экраны подписки (крестик или кнопка СПАСИБО), Story остаётся
    func closeAll() {
        onCloseAll()
    }
}
