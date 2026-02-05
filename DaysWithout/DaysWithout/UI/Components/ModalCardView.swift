//
//  ModalCardView.swift
//  DaysWithout
//

import SwiftUI

/// Обёртка модального контента: фон, скругление, обводка и тени (кнопку закрытия экран добавляет сам).
struct ModalCardView<Content: View>: View {
    let strokeLineWidth: CGFloat
    @ViewBuilder let content: () -> Content

    init(
        strokeLineWidth: CGFloat = Theme.addHabitModalStrokeLineWidth,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.strokeLineWidth = strokeLineWidth
        self.content = content
    }

    var body: some View {
        content()
            .background(Color.white.opacity(Theme.addHabitModalBackgroundOpacity))
            .clipShape(RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius)
                    .stroke(Theme.addHabitModalBorderColor, lineWidth: strokeLineWidth)
            }
            .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.addHabitModalShadowRadius, x: 0, y: Theme.addHabitModalShadowY)
            .overlay {
                RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [Theme.addHabitModalInnerShadowColor, Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: Theme.addHabitModalInnerShadowOffsetY)
                    .blur(radius: Theme.addHabitModalInnerShadowBlur)
                    .mask(RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius))
                    .allowsHitTesting(false)
            }
    }
}
