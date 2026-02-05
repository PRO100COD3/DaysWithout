//
//  CharacterLimitAlertView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Алерт для отображения ошибок валидации названия привычки
/// Показывается сверху экрана при ошибках ввода
struct CharacterLimitAlertView: View {
    
    // MARK: - Properties
    
    let message: String
    @Binding var isPresented: Bool
    
    // MARK: - Body
    
    var body: some View {
        if isPresented {
            HStack {
                Text(message)
                    .font(.custom(Theme.headingFontName, size: Theme.characterLimitAlertFontSize))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.characterLimitAlertTextColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, Theme.characterLimitAlertHorizontalPadding)
            .frame(height: Theme.characterLimitAlertHeight)
            .background {
                RoundedRectangle(cornerRadius: Theme.characterLimitAlertCornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Theme.characterLimitAlertGradientTop,
                                Theme.characterLimitAlertGradientBottom
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        CharacterLimitAlertView(message: "Введите название", isPresented: .constant(true))
        CharacterLimitAlertView(message: "Максимальное кол-во символов - 17", isPresented: .constant(true))
        Spacer()
    }
    .background(Color.gray.opacity(Theme.previewOverlayLightOpacity))
}
