//
//  MainView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Главный экран приложения
/// Отображает список карточек привычек и кнопку добавления
struct MainView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: MainViewModel
    
    // MARK: - Initialization
    
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider
    ) {
        _viewModel = StateObject(wrappedValue: MainViewModel(
            habitService: habitService,
            userStatusProvider: userStatusProvider
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.backgroundColor[0], Theme.backgroundColor[1]], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Заголовок
                headerView
                
                // Контент
                contentView
                
                Spacer()
            }
            
            // Кнопка "Добавить" (отображается только если не достигнут лимит статуса пользователя)
            if viewModel.shouldShowAddButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddHabitButtonView()
                            .padding(.trailing, Theme.buttonPadding)
                            .padding(.bottom, Theme.buttonPadding)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 0) {
            Text("Привычки")
                .font(.custom("Onest", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            Divider()
                .background(Theme.DeviderColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, 20)
        }
    }
    
    // MARK: - Content
    
    private var contentView: some View {
        Group {
            if viewModel.cards.isEmpty {
                emptyStateView
            } else {
                cardsGridView
            }
        }
    }
//        .padding(.top, 12)
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: 14) {
            Text("Добавьте первую привычку")
                .font(.custom("Onest", size: 18))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainHeadingColor)
            
            Text("Маленький шаг \nк большим изменениям")
                .font(.custom("Onest", size: 14))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainDescriptionColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 34)
    }
    
    // MARK: - Cards Grid
    
    private var cardsGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Theme.cardSpacing),
                    GridItem(.flexible(), spacing: Theme.cardSpacing)
                ],
                spacing: Theme.cardSpacing
            ) {
                // Отображаем карточки с учетом лимита статуса пользователя (Free: 3, Pro: 6)
                ForEach(viewModel.displayableCards) { card in
                    HabitCardView(card: card)
                        .aspectRatio(0.75, contentMode: .fit) // Соотношение сторон карточки
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, Theme.screenPadding)
            .padding(.bottom, 80) // Отступ для кнопки "Добавить"
        }
    }
}

// MARK: - Preview

#Preview {
    MainView(
        habitService: HabitService(
            storageService: UserDefaultsStorageService(),
            userStatusProvider: DefaultUserStatusProvider()
        ),
        userStatusProvider: DefaultUserStatusProvider()
    )
}
