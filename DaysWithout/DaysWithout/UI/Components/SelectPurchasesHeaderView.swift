//
//  SelectPurchasesHeaderView.swift
//  DaysWithout
//

import SwiftUI

/// Заголовок экрана выбора подписки: название и описание.
struct SelectPurchasesHeaderView: View {
    let title: String
    let descriptionText: String

    var body: some View {
        VStack(alignment: .center, spacing: Theme.selectPurchasesHeaderSpacing) {
            Text(title)
                .font(.custom(Theme.headingFontName, size: Theme.selectPurchasesTitleFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.mainHeadingColor)
            Text(descriptionText)
                .font(.custom(Theme.headingFontName, size: Theme.selectPurchasesDescriptionFontSize))
                .fontWeight(.regular)
                .foregroundColor(Theme.selectPurchasesDescriptionColor)
        }
        .frame(maxWidth: .infinity)
    }
}
