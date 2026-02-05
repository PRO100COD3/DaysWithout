//
//  MainFloatingAddButtonView.swift
//  DaysWithout
//

import SwiftUI

/// Плавающая кнопка «Добавить» в правом нижнем углу главного экрана.
struct MainFloatingAddButtonView: View {
    let onTap: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                AddHabitButtonView(onTap: onTap)
                    .padding(.trailing, Theme.buttonPadding)
                    .padding(.bottom, Theme.buttonPadding)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
