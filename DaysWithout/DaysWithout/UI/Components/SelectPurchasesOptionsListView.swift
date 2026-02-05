//
//  SelectPurchasesOptionsListView.swift
//  DaysWithout
//

import SwiftUI

/// Список опций подписки (Месяц / Год / Навсегда).
struct SelectPurchasesOptionsListView: View {
    let options: [SubscriptionOption]
    let selectedIndex: Int
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(spacing: Theme.selectPurchasesOptionsSpacing) {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                SelectPurchasesOptionRowView(
                    option: option,
                    isSelected: selectedIndex == index,
                    action: { onSelect(index) }
                )
            }
        }
    }
}
