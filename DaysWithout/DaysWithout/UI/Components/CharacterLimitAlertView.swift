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
                    .font(.custom(Theme.headingFontName, size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
            .padding(24)
            .frame(height: 58)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.612, blue: 0.612),
                                Color(red: 0.906, green: 0.329, blue: 0.329)
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
    .background(Color.gray.opacity(0.1))
}
