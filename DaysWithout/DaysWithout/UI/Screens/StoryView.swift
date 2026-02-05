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
            VStack(spacing: Theme.storyContentStackSpacing) {
                ScreenHeaderView(
                    title: viewModel.cardTitle,
                    titleFontSize: Theme.storyHeaderTitleFontSize,
                    titleColor: Theme.storyHeaderTitleColor,
                    horizontalPadding: Theme.storyHeaderHorizontalPadding,
                    topPadding: Theme.storyHeaderTopPadding,
                    leading: {
                        Button(action: onDismiss) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: Theme.storyHeaderChevronFontSize, weight: .semibold))
                                .foregroundColor(Theme.mainHeadingColor)
                        }
                        .frame(width: Theme.storyHeaderButtonSize, height: Theme.storyHeaderButtonSize)
                    },
                    trailing: {
                        Button(action: viewModel.openSupport) {
                            Image("coins")
                                .font(.system(size: Theme.storyHeaderChevronFontSize, weight: .semibold))
                                .foregroundColor(Theme.mainHeadingColor)
                        }
                        .frame(width: Theme.storyHeaderCoinsButtonSize, height: Theme.storyHeaderCoinsButtonSize)
                    }
                )
                if viewModel.isEmpty {
                    StoryPlaceholderView()
                } else {
                    StoryHistoryListView(history: viewModel.history)
                }
            }
            .onAppear {
                viewModel.loadHistory()
            }
            .overlay {
                if viewModel.isSupportPresented || viewModel.isSelectPurchasesPresented {
                    Color.black.opacity(Theme.modalOverlayOpacity)
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
                    .padding(.horizontal, Theme.screenPadding)
                }
            }
            .overlay {
                if viewModel.isSelectPurchasesPresented {
                    SelectPurchasesView(onCloseAll: viewModel.dismissSupportFlowKeepStory)
                        .padding(.horizontal, Theme.screenPadding)
                }
            }
        }
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
