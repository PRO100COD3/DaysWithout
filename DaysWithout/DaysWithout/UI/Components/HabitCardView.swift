//
//  HabitCardView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Компонент карточки привычки
/// Отображает карточку с градиентом, прогресс-рингом, количеством дней и таймером
struct HabitCardView: View {
    
    // MARK: - Properties
    
    let card: HabitCard
    
    @State private var isPressed = false
    @State private var remainingTime: TimeInterval = 0
    
    // Таймер для обновления каждую секунду
    @State private var timer: Timer?
    
    // MARK: - Body
    
    var body: some View {
        let colors = Theme.cardColor(for: card.colorID)
        
        ZStack {
            // Градиентный фон
            LinearGradient(
                colors: [colors.top, colors.bottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(Theme.cardCornerRadius)
            
            // Контент карточки
            VStack(spacing: 16) {
                // Название привычки
                Text(card.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.cardTextColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                
                Spacer()
                
                // Прогресс-ринг с количеством дней
                progressRingView
                
                Spacer()
                
                // Таймер
                timerView
            }
            .padding(Theme.cardPadding)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .opacity(isPressed ? 0.8 : 1.0)
        .animation(Theme.pressAnimationType, value: isPressed)
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onTapGesture {
            handlePress()
        }
    }
    
    // MARK: - Progress Ring
    
    private var progressRingView: some View {
        ZStack {
            // Фоновый круг
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 8)
                .frame(width: Theme.progressRingSize, height: Theme.progressRingSize)
            
            // Прогресс (заполненная часть)
            Circle()
                .trim(from: 0, to: progressValue)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: Theme.progressRingSize, height: Theme.progressRingSize)
                .rotationEffect(.degrees(-90))
            
            // Количество дней
            VStack(spacing: 4) {
                Text("\(card.daysCount)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(Theme.cardTextColor)
                
                Text("дней")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Theme.cardTextColor.opacity(0.9))
            }
        }
    }
    
    // MARK: - Timer
    
    private var timerView: some View {
        Text(timerString)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(Theme.cardTextColor.opacity(0.9))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Computed Properties
    
    /// Значение прогресса (0.0 - 1.0) для прогресс-ринга
    private var progressValue: Double {
        // Вычисляем прогресс в текущем 24-часовом периоде
        let elapsed = Date().timeIntervalSince(card.startDate)
        let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.secondsInDay)
        return min(elapsedInCurrentPeriod / TimerConstants.secondsInDay, 1.0)
    }
    
    /// Строковое представление таймера (формат MM:SS)
    private var timerString: String {
        let totalSeconds = Int(remainingTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Methods
    
    /// Запускает таймер обновления
    private func startTimer() {
        updateTimer() // Обновляем сразу
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [card] _ in
            // Вычисляем оставшееся время на основе текущей даты и startDate карточки
            let elapsed = Date().timeIntervalSince(card.startDate)
            let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.secondsInDay)
            let remaining = TimerConstants.secondsInDay - elapsedInCurrentPeriod
            
            DispatchQueue.main.async {
                remainingTime = max(0, remaining)
            }
        }
        
        if let timer = timer {
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    /// Останавливает таймер
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// Обновляет значение таймера (вызывается при появлении view)
    private func updateTimer() {
        let elapsed = Date().timeIntervalSince(card.startDate)
        let elapsedInCurrentPeriod = elapsed.truncatingRemainder(dividingBy: TimerConstants.secondsInDay)
        remainingTime = max(0, TimerConstants.secondsInDay - elapsedInCurrentPeriod)
    }
    
    /// Обрабатывает нажатие на карточку
    private func handlePress() {
        isPressed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Theme.pressAnimationDuration) {
            isPressed = false
        }
    }
}

// MARK: - Preview

#Preview {
    HabitCardView(
        card: HabitCard(
            title: "Дни без сахара",
            startDate: Date().addingTimeInterval(-132 * 24 * 3600),
            colorID: 1
        )
    )
    .frame(width: 180, height: 240)
    .padding()
}
