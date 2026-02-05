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
    var onTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            handlePress()
        }) {
            Image(systemName: "plus")
                .font(.system(size: Theme.addButtonIconFontSize, weight: .semibold))
                .foregroundColor(Theme.addButtonIconColor)
                .frame(width: Theme.addButtonSize, height: Theme.addButtonSize)
                .background(Theme.addButtonColor)
                .clipShape(Circle())
                .overlay(
                    // Внутренняя тень (эмулируется через белый круг с blur)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Theme.buttonInnerShadowColor.opacity(0),
                                    Theme.buttonInnerShadowColor
                                ],
                                center: .topLeading,
                                startRadius: Theme.addButtonSize * Theme.buttonInnerShadowStartRadiusMultiplier,
                                endRadius: Theme.addButtonSize * Theme.buttonInnerShadowEndRadiusMultiplier
                            )
                        )
                        .blur(radius: Theme.buttonInnerShadowRadius)
                        .offset(
                            x: Theme.buttonInnerShadowX,
                            y: Theme.buttonInnerShadowY
                        )
                        .clipShape(Circle())
                )
        }
        .shadow(
            color: Theme.buttonDropShadowColor,
            radius: Theme.buttonDropShadowRadius + Theme.buttonDropShadowSpread,
            x: Theme.buttonDropShadowX,
            y: Theme.buttonDropShadowY
        )
        .scaleEffect(isPressed ? Theme.buttonPressScale : 1.0)
        .opacity(isPressed ? Theme.buttonPressOpacity : 1.0)
    }
    
    // MARK: - Methods
    
    /// Обрабатывает нажатие на кнопку
    private func handlePress() {
        isPressed = true
        DispatchQueue.main.asyncAfter(deadline: .now() + Theme.pressAnimationDuration) {
            isPressed = false
        }
        
        // Вызываем callback для открытия экрана добавления
        onTap()
    }
}

// MARK: - Preview

#Preview {
    ZStack {        
        AddHabitButtonView(onTap: {})
    }
}
