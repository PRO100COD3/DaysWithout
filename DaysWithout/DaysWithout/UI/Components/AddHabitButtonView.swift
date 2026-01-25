//
//  AddHabitButtonView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Кнопка "Добавить" для создания новой привычки
/// Отображается только если можно создать новую карточку
struct AddHabitButtonView: View {
    
    // MARK: - Properties
    
    @State private var isPressed = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            handlePress()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: Theme.addButtonSize, height: Theme.addButtonSize)
                .background(Theme.addButtonColor)
                .clipShape(Circle())
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .opacity(isPressed ? 0.8 : 1.0)
        .animation(Theme.pressAnimationType, value: isPressed)
    }
    
    // MARK: - Methods
    
    /// Обрабатывает нажатие на кнопку
    private func handlePress() {
        isPressed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Theme.pressAnimationDuration) {
            isPressed = false
        }
        
        // На этапе 3 создание карточек не реализовано
        // Кнопка только визуально реагирует на нажатие
    }
}

// MARK: - Preview

#Preview {
    ZStack {
//        Color.gray.opacity(0.1)
//            .ignoresSafeArea()
        
        AddHabitButtonView()
    }
}
