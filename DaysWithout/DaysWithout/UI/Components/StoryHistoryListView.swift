//
//  StoryHistoryListView.swift
//  DaysWithout
//

import SwiftUI

/// Список записей истории рестартов (ScrollView + ячейки).
struct StoryHistoryListView: View {
    let history: [RestartRecord]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: Theme.storyHistoryListSpacing) {
                ForEach(history) { record in
                    StoryHistoryCellView(
                        daysText: StoryViewModel.daysText(for: record.days),
                        reason: record.reason.isEmpty ? nil : record.reason,
                        dateRangeText: StoryViewModel.formatDateRange(periodStart: record.periodStart, periodEnd: record.periodEnd)
                    )
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, Theme.storyHistoryListTopPadding)
        }
    }
}
