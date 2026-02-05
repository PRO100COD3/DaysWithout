//
//  MainAddHabitOverlayView.swift
//  DaysWithout
//

import SwiftUI

/// Оверлей добавления привычки: затемнённый фон и модальное окно AddHabit по центру.
struct MainAddHabitOverlayView: View {
    let habitService: HabitServiceProtocol
    let userStatusProvider: UserStatusProvider
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(Theme.modalOverlayOpacity)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack {
                Spacer()
                AddHabitView(
                    habitService: habitService,
                    userStatusProvider: userStatusProvider,
                    onDismiss: onDismiss
                )
                .frame(maxWidth: .infinity)
                .padding(.horizontal, Theme.addHabitModalHorizontalMargin)
                Spacer()
            }
        }
        .zIndex(Theme.mainModalZIndex)
    }
}
