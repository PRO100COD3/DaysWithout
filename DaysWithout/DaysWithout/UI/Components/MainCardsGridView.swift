//
//  MainCardsGridView.swift
//  DaysWithout
//

import SwiftUI

/// Сетка карточек привычек на главном экране.
struct MainCardsGridView: View {
    let cards: [HabitCard]
    let timerService: TimerServiceProtocol
    let onTap: (HabitCard) -> Void

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: Theme.gridColumnSpacing), count: Theme.mainGridColumnCount),
                spacing: Theme.gridRowSpacing
            ) {
                ForEach(cards) { card in
                    HabitCardView(
                        card: card,
                        timerService: timerService,
                        onTap: onTap
                    )
                    .frame(height: Theme.cardHeight)
                }
            }
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, Theme.gridTopPadding)
        }
    }
}
