//
//  StoryView.swift
//  DaysWithout
//

import SwiftUI

/// Экран истории рестартов: заглушка при отсутствии данных или список записей с датой и причиной.
struct StoryView: View {
    let card: HabitCard
    let restartHistoryService: RestartHistoryServiceProtocol
    let onDismiss: () -> Void
    
    @StateObject private var viewModel: StoryViewModel
    
    init(card: HabitCard, restartHistoryService: RestartHistoryServiceProtocol, onDismiss: @escaping () -> Void) {
        self.card = card
        self.restartHistoryService = restartHistoryService
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: StoryViewModel(card: card, restartHistoryService: restartHistoryService))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            if viewModel.isEmpty {
                placeholderView
            } else {
                historyListView
            }
        }
        .background(Theme.backgroundColor[1].ignoresSafeArea())
        .onAppear {
            viewModel.loadHistory()
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
            }
            .frame(width: 44, height: 44)
            Spacer()
            Text(viewModel.cardTitle)
                .font(.custom(Theme.headingFontName, size: Theme.mainHeadingFontSize))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
            Spacer()
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Divider()
                .background(Theme.DeviderColor)
        }
    }
    
    private var placeholderView: some View {
        VStack(spacing: 0) {
            Spacer()
            Text("После нажатия рестарта у вас отобразится история")
                .font(.custom(Theme.headingFontName, size: Theme.emptyStateDescriptionFontSize))
                .foregroundColor(Theme.mainDescriptionColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.screenPadding * 2)
            Spacer()
        }
    }
    
    private var historyListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.history) { record in
                    historyCell(record: record)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 20)
            .padding(.bottom, 24)
        }
    }
    
    private func historyCell(record: RestartRecord) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(StoryViewModel.daysText(for: record.days))
                .font(.custom(Theme.headingFontName, size: Theme.cardDaysCountFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.cardColor(for: card.colorID).top)
            if !record.reason.isEmpty {
                Text(record.reason)
                    .font(.custom(Theme.cardFontName, size: Theme.cardSmallTextFontSize))
                    .foregroundColor(Theme.mainDescriptionColor)
            }
            Text(StoryViewModel.formatDateRange(periodStart: record.periodStart, periodEnd: record.periodEnd))
                .font(.custom(Theme.cardFontName, size: Theme.cardSmallTextFontSize))
                .foregroundColor(Theme.mainDescriptionColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .shadow(color: Theme.cardShadowColor, radius: Theme.cardShadowRadius, x: Theme.cardShadowX, y: Theme.cardShadowY)
    }
}

#Preview("Empty") {
    let card = HabitCard(title: "Дни без кофе", startDate: Date(), colorID: 1)
    let service = RestartHistoryService()
    return StoryView(card: card, restartHistoryService: service, onDismiss: {})
}

#Preview("With data") {
    let card = HabitCard(title: "Дни без кофе", startDate: Date(), colorID: 1)
    let service = RestartHistoryService()
    let start = Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()
    let end = Date()
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    return StoryView(card: card, restartHistoryService: service, onDismiss: {})
}
