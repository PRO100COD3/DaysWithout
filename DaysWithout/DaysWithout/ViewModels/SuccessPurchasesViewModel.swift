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
    
    /// Вызывается при закрытии (кнопка СПАСИБО или крестик) — закрыть весь флоу
    var onCloseAll: (() -> Void)?
    
    /// Закрыть весь флоу (кнопка СПАСИБО или крестик)
    func closeAll() {
        onCloseAll?()
    }
}
