//
//  HabitCardView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Компонент карточки привычки
/// Отображает карточку с градиентом, прогресс-рингом, количеством дней и таймером
/// Вся логика таймера и расчетов находится в HabitCardViewModel
struct HabitCardView: View {
    
    // MARK: - Properties
    
    let card: HabitCard
    let timerService: TimerServiceProtocol
    var onTap: ((HabitCard) -> Void)?
    
    @StateObject private var viewModel: HabitCardViewModel
    
    // MARK: - Initialization
    
    init(card: HabitCard, timerService: TimerServiceProtocol, onTap: ((HabitCard) -> Void)? = nil) {
        self.card = card
        self.timerService = timerService
        self.onTap = onTap
        _viewModel = StateObject(wrappedValue: HabitCardViewModel(
            card: card,
            timerService: timerService
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        let colors = Theme.cardColor(for: card.colorID)
        
        ZStack {
            // Градиентный фон с тенью (тень только у фона карточки)
            LinearGradient(
                colors: [colors.top, colors.bottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(Theme.cardCornerRadius)
            .shadow(
                color: Theme.cardShadowColor,
                radius: Theme.cardShadowRadius,
                x: Theme.cardShadowX,
                y: Theme.cardShadowY
            )
            
            // Контент карточки (без тени)
            VStack(spacing: Theme.cardContentStackSpacing) {
                // Название привычки
                Text(card.title)
                    .font(.custom(Theme.cardFontName, size: Theme.cardTitleFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.cardTextHeaderColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .lineLimit(Theme.cardTitleLineLimit)
                    .padding(.bottom, Theme.cardTitleBottomPadding)
                                
                // Прогресс-ринг с количеством дней
                progressRingView
                    .padding(.bottom, Theme.cardProgressRingBottomPadding)
                                
                // Таймер
                timerView
            }
            .padding(.top, Theme.cardContentTopPadding)
            .padding(.bottom, Theme.cardContentBottomPadding)
        }
        .scaleEffect(viewModel.isPressed ? Theme.cardPressScale : Theme.cardIdleScale)
        .opacity(viewModel.isPressed ? Theme.cardPressOpacity : Theme.cardIdleOpacity)
        .onTapGesture {
            viewModel.triggerPress(duration: Theme.pressAnimationDuration)
            onTap?(card)
        }
        .onChange(of: card.startDate) { _ in
            viewModel.updateCard(card)
        }
    }
    
    // MARK: - Progress Ring
    
    private var progressRingView: some View {
        ZStack {
            // Фоновый круг
            Circle()
                .stroke(
                    Theme.cardCircleColor.opacity(Theme.progressRingBackgroundOpacity),
                    lineWidth: Theme.progressRingLineWidth
                )
                .frame(width: Theme.progressRingSize, height: Theme.progressRingSize)
            
            // Прогресс (заполненная часть)
            Circle()
                .trim(from: 0, to: viewModel.progressValue)
                .stroke(
                    Theme.cardCircleColor,
                    style: StrokeStyle(
                        lineWidth: Theme.progressRingLineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: Theme.progressRingSize, height: Theme.progressRingSize)
                .rotationEffect(.degrees(Theme.progressRingRotationDegrees))
            
            // Количество дней
            VStack(spacing: Theme.cardContentStackSpacing) {
                Text("\(card.daysCount)")
                    .font(.custom(Theme.cardFontName, size: Theme.cardDaysCountFontSize))
                    .fontWeight(.bold)
                    .foregroundColor(Theme.cardTextColor)
                
                Text("дней")
                    .font(.custom(Theme.cardFontName, size: Theme.cardSmallTextFontSize))
                    .fontWeight(.regular)
                    .foregroundColor(Theme.cardTextHeaderColor)
            }
        }
    }
    
    // MARK: - Timer
    
    private var timerView: some View {
        Text(viewModel.timerString)
            .font(.custom(Theme.cardFontName, size: Theme.cardSmallTextFontSize))
            .fontWeight(.regular)
            .foregroundColor(Theme.cardTextColor)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
}

// MARK: - Preview

#Preview {
    let card = HabitCard(
        title: "Дни без сахара",
        startDate: Date().addingTimeInterval(-132 * 24 * 3600),
        colorID: 1
    )
    let habitService = HabitService(
        storageService: UserDefaultsStorageService(),
        userStatusProvider: DefaultUserStatusProvider()
    )
    let timerService = TimerService(habitService: habitService)
    
    return HabitCardView(card: card, timerService: timerService)
        .frame(width: Theme.cardPreviewWidth, height: 0)
}
