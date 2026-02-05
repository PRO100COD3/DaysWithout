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
        _viewModel = StateObject(wrappedValue: StoryViewModel(card: card, restartHistoryService: restartHistoryService, onFullDismiss: onDismiss))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Theme.backgroundColor[0], Theme.backgroundColor[1]], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                if viewModel.isEmpty {
                    placeholderView
                } else {
                    historyListView
                }
            }
            .onAppear {
                viewModel.loadHistory()
            }
            .overlay {
                if viewModel.isSupportPresented || viewModel.isSelectPurchasesPresented {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { viewModel.dismissSupportFlowKeepStory() }
                }
            }
            .overlay {
                if viewModel.isSupportPresented {
                    SupportView(
                        onSupportTap: viewModel.openSelectPurchases,
                        onCloseAll: viewModel.dismissSupportFlowKeepStory
                    )
                    .padding(.horizontal, 23)
                }
            }
            .overlay {
                if viewModel.isSelectPurchasesPresented {
                    SelectPurchasesView(onCloseAll: viewModel.dismissSupportFlowKeepStory)
                    .padding(.horizontal, 23)
                }
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
            }
            .frame(width: 24, height: 24)
            Spacer()
            Text(viewModel.cardTitle)
                .font(.custom("Onest", size: 20))
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
            Button(action: viewModel.openSupport) {
                Image("coins")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
            }
            .frame(width: 36, height: 36)
        }
        .padding(.horizontal, 16)
        .padding(.top, 7)
    }
    
    private var placeholderView: some View {
        VStack(spacing: 0) {
            Text("После нажатия рестарта у вас отобразится история")
                .font(.custom("Onest", size: 18))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainHeadingColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.screenPadding * 2)
            Spacer()
        }
        .padding(.top, 37)
    }
    
    private var historyListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.history) { record in
                    historyCell(record: record)
                }
            }
            .padding(.horizontal, 23)
            .padding(.top, 44)
        }
    }
    
    private func historyCell(record: RestartRecord) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(StoryViewModel.daysText(for: record.days))
                .font(.custom("Onest", size: 18))
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 72/255, green: 153/255, blue: 39/255))
            if !record.reason.isEmpty {
                Text(record.reason)
                    .font(.custom("Onest", size: 18))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 154/255, green: 154/255, blue: 154/255))
            }
            Text(StoryViewModel.formatDateRange(periodStart: record.periodStart, periodEnd: record.periodEnd))
                .font(.custom("Onest", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white.opacity(0.95))
        .overlay(RoundedRectangle(cornerRadius: 24)
            .stroke(
                Color.black.opacity(0.08),
                lineWidth: 1
            ))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.black.opacity(0.06), radius: 36, x: 0, y: 8)
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
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    service.addRecord(cardId: card.id, record: RestartRecord(days: 5, reason: "Текст причины", periodStart: start, periodEnd: end))
    return StoryView(card: card, restartHistoryService: service, onDismiss: {})
}
