//
//  SupportViewModel.swift
//  DaysWithout
//

import Foundation
import Combine

/// ViewModel экрана «Поддержать разработчика». Управляет закрытием; не содержит UI-кода.
@MainActor
final class SupportViewModel: ObservableObject {
    
    /// Заголовок экрана
    var title: String { "Поддержать разработчика" }
    
    /// Текст сообщения
    var message: String { "Если приложение было полезным, вы можете поддержать его развитие" }
    
    /// Текст кнопки
    var buttonTitle: String { "ПОДДЕРЖАТЬ" }
    
    private let onCloseAll: () -> Void
    private let onSupportTap: () -> Void
    
    init(onSupportTap: @escaping () -> Void, onCloseAll: @escaping () -> Void) {
        self.onSupportTap = onSupportTap
        self.onCloseAll = onCloseAll
    }
    
    /// Закрыть весь флоу (крестик или тап по фону)
    func closeAll() {
        onCloseAll()
    }
    
    /// Нажатие кнопки «ПОДДЕРЖАТЬ» — открыть экран выбора подписки
    func supportTapped() {
        onSupportTap()
    }
}
