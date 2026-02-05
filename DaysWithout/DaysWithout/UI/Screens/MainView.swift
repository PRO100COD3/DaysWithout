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
    private let restartHistoryService: RestartHistoryServiceProtocol
    
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider,
        timerService: TimerServiceProtocol,
        restartHistoryService: RestartHistoryServiceProtocol
    ) {
        self.timerService = timerService
        self.habitService = habitService
        self.userStatusProvider = userStatusProvider
        self.restartHistoryService = restartHistoryService
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

            VStack(spacing: Theme.mainContentStackSpacing) {
                MainHeaderView()
                contentView
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)

            if viewModel.shouldShowAddButton {
                MainFloatingAddButtonView(onTap: viewModel.presentAddHabit)
            }
        }
        .blur(radius: viewModel.isAddHabitPresented ? Theme.addHabitBackdropBlurRadius : 0)
        .overlay {
            if viewModel.isAddHabitPresented {
                MainAddHabitOverlayView(
                    habitService: habitService,
                    userStatusProvider: userStatusProvider,
                    onDismiss: viewModel.dismissAddHabit
                )
            }
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { viewModel.selectedCardForTimer != nil },
                set: { if !$0 { DispatchQueue.main.async { viewModel.dismissTimer() } } }
            )
        ) {
            if let card = viewModel.selectedCardForTimer {
                TimerView(
                    card: card,
                    habitService: habitService,
                    restartHistoryService: restartHistoryService,
                    onDismiss: { viewModel.dismissTimer() }
                )
            }
        }
    }
    
    // MARK: - Content

    private var contentView: some View {
        Group {
            if viewModel.cards.isEmpty {
                MainEmptyStateView(
                    title: "Добавьте первую привычку",
                    subtitle: "Маленький шаг \nк большим изменениям"
                )
            } else {
                MainCardsGridView(
                    cards: viewModel.displayableCards,
                    timerService: timerService,
                    onTap: { viewModel.presentTimer(card: $0) }
                )
            }
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
    let restartHistoryService = RestartHistoryService()
    
    MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService, restartHistoryService: restartHistoryService
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
    let restartHistoryService = RestartHistoryService()
    
    MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService, restartHistoryService: restartHistoryService
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
    let restartHistoryService = RestartHistoryService()
    
    MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService, restartHistoryService: restartHistoryService
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
    let restartHistoryService = RestartHistoryService()
    
    MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService, restartHistoryService: restartHistoryService
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
    let restartHistoryService = RestartHistoryService()
    
    MainView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        timerService: timerService, restartHistoryService: restartHistoryService
    )
}
