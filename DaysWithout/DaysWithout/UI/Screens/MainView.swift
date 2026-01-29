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
    
    private let timerService: TimerServiceProtocol
    private let habitService: HabitServiceProtocol
    private let userStatusProvider: UserStatusProvider
    
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider,
        timerService: TimerServiceProtocol
    ) {
        self.timerService = timerService
        self.habitService = habitService
        self.userStatusProvider = userStatusProvider
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
            .ignoresSafeArea(edges: .bottom)
            // Кнопка "Добавить" (отображается только если не достигнут лимит статуса пользователя)
            if viewModel.shouldShowAddButton {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddHabitButtonView(onTap: {
                            viewModel.presentAddHabit()
                        })
                        .padding(.trailing, Theme.buttonPadding)
                        .padding(.bottom, Theme.buttonPadding)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .blur(radius: viewModel.isAddHabitPresented ? Theme.addHabitBackdropBlurRadius : 0)
        .overlay {
            if viewModel.isAddHabitPresented {
                // Задний фон: затемнение rgba(0, 0, 0, 0.3)
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                viewModel.dismissAddHabit()
                            }
                        }
                    
                    // Модальное окно по центру
                    VStack {
                        Spacer()
                        
                        AddHabitView(
                            habitService: habitService,
                            userStatusProvider: userStatusProvider,
                            onDismiss: {
                                withAnimation {
                                    viewModel.dismissAddHabit()
                                }
                            }
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, Theme.addHabitModalHorizontalMargin)
                        
                        Spacer()
                    }
                }
                .transition(.opacity)
                .zIndex(1000)
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 0) {
            Text("Привычки")
                .font(.custom(Theme.headingFontName, size: Theme.mainHeadingFontSize))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.top, Theme.headerTopPadding)
                .padding(.bottom, Theme.headerBottomPadding)
            
            Divider()
                .background(Theme.DeviderColor)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, Theme.dividerBottomPadding)
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
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: Theme.emptyStateSpacing) {
            Text("Добавьте первую привычку")
                .font(.custom(Theme.headingFontName, size: Theme.emptyStateHeadingFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainHeadingColor)
            
            Text("Маленький шаг \nк большим изменениям")
                .font(.custom(Theme.headingFontName, size: Theme.emptyStateDescriptionFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainDescriptionColor)
                .multilineTextAlignment(.center)
        }
        .padding(.top, Theme.emptyStateTopPadding)
    }
    
    // MARK: - Cards Grid
    
    private var cardsGridView: some View {
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Theme.gridColumnSpacing),
                    GridItem(.flexible(), spacing: Theme.gridColumnSpacing)
                ],
                spacing: Theme.gridRowSpacing
            ) {
                // Отображаем карточки с учетом лимита статуса пользователя
                ForEach(viewModel.displayableCards) { card in
                    HabitCardView(card: card, timerService: timerService)
                        .frame(height: Theme.cardHeight)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, Theme.gridTopPadding)
        }
    }
}

// MARK: - Preview
#Preview("Нет данных") {
    let habitService = HabitService(
        storageService: TestStorageService(cards: []),
        userStatusProvider: DefaultUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService
    )
}

#Preview("1 карточка") {
    let testCards = [
        HabitCard(
            title: "Дни без кофе",
            startDate: Date().addingTimeInterval(-10 * 24 * 3600),
            colorID: 2
        )
    ]
    let habitService = HabitService(
        storageService: TestStorageService(cards: testCards),
        userStatusProvider: DefaultUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService
    )
}

#Preview("3 карточки (Free)") {
    let testCards = [
        HabitCard(
            title: "Дни без сахара",
            startDate: Date().addingTimeInterval(-132 * 24 * 3600),
            colorID: 1
        ),
        HabitCard(
            title: "Дни без кофе",
            startDate: Date().addingTimeInterval(-50 * 24 * 3600),
            colorID: 2
        ),
        HabitCard(
            title: "Дни без видеоигр",
            startDate: Date().addingTimeInterval(-30 * 24 * 3600),
            colorID: 3
        )
    ]
    let habitService = HabitService(
        storageService: TestStorageService(cards: testCards),
        userStatusProvider: DefaultUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService
    )
}

#Preview("6 карточек (Pro)") {
    let testCards = [
        HabitCard(
            title: "Дни без сахара",
            startDate: Date().addingTimeInterval(-132 * 24 * 3600),
            colorID: 1
        ),
        HabitCard(
            title: "Дни без кофе",
            startDate: Date().addingTimeInterval(-100 * 24 * 3600),
            colorID: 2
        ),
        HabitCard(
            title: "Дни без видеоигр",
            startDate: Date().addingTimeInterval(-80 * 24 * 3600),
            colorID: 3
        ),
        HabitCard(
            title: "Дни без алкоголя",
            startDate: Date().addingTimeInterval(-60 * 24 * 3600),
            colorID: 4
        ),
        HabitCard(
            title: "Дни без сигарет",
            startDate: Date().addingTimeInterval(-40 * 24 * 3600),
            colorID: 5
        ),
        HabitCard(
            title: "Дни без осуждений",
            startDate: Date().addingTimeInterval(-20 * 24 * 3600),
            colorID: 6
        )
    ]
    let habitService = HabitService(
        storageService: TestStorageService(cards: testCards),
        userStatusProvider: ProUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return MainView(
        habitService: habitService,
        userStatusProvider: ProUserStatusProvider(),
        timerService: timerService
    )
}

#Preview("5 карточек (Pro)") {
    let testCards = [
        HabitCard(
            title: "Дни без сахара",
            startDate: Date().addingTimeInterval(-132 * 24 * 3600),
            colorID: 1
        ),
        HabitCard(
            title: "Дни без кофе",
            startDate: Date().addingTimeInterval(-100 * 24 * 3600),
            colorID: 2
        ),
        HabitCard(
            title: "Дни без алкоголя",
            startDate: Date().addingTimeInterval(-60 * 24 * 3600),
            colorID: 4
        ),
        HabitCard(
            title: "Дни без сигарет",
            startDate: Date().addingTimeInterval(-40 * 24 * 3600),
            colorID: 5
        ),
        HabitCard(
            title: "Дни без осуждений",
            startDate: Date().addingTimeInterval(-20 * 24 * 3600),
            colorID: 6
        )
    ]
    let habitService = HabitService(
        storageService: TestStorageService(cards: testCards),
        userStatusProvider: ProUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return MainView(
        habitService: habitService,
        userStatusProvider: ProUserStatusProvider(),
        timerService: timerService
    )
}
