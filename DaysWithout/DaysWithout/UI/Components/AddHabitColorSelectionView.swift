//
//  AddHabitColorSelectionView.swift
//  DaysWithout
//

import SwiftUI

/// Блок выбора цвета карточки: заголовок и сетка кружков.
struct AddHabitColorSelectionView: View {
    let sectionTitle: String
    @Binding var selectedColorID: Int

    init(sectionTitle: String = "Цвет карточки", selectedColorID: Binding<Int>) {
        self.sectionTitle = sectionTitle
        self._selectedColorID = selectedColorID
    }

    var body: some View {
        VStack(alignment: .center, spacing: Theme.addHabitColorSectionSpacing) {
            Text(sectionTitle)
                .font(.custom(Theme.headingFontName, size: Theme.addHabitInputFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.addHabitHeadingColor)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: Theme.addHabitColorSectionSpacing), count: Theme.addHabitColorGridColumnCount),
                spacing: Theme.addHabitColorSectionSpacing
            ) {
                ForEach(1...Theme.addHabitColorCount, id: \.self) { colorID in
                    AddHabitColorCircleView(
                        colorID: colorID,
                        isSelected: selectedColorID == colorID,
                        action: { selectedColorID = colorID }
                    )
                }
            }
        }
    }
}
