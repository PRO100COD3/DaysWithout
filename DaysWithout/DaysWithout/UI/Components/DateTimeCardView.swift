//
//  DateTimeCardView.swift
//  DaysWithout
//

import SwiftUI

/// Карточка выбора времени: пикер часов/минут, линии выделения и кнопка «СОЗДАТЬ».
struct DateTimeCardView: View {
    @Binding var hourSelection: Int
    @Binding var minuteSelection: Int
    let onConfirm: () -> Void

    var body: some View {
        DateStepCardView {
            VStack(spacing: Theme.dateContentStackSpacing) {
                TimePickerView(hourSelection: $hourSelection, minuteSelection: $minuteSelection)
                    .padding(.top, Theme.dateTimeWheelTopPadding)
                    .frame(height: Theme.dateTimeWheelVisibleHeight)
                DateCreateButtonView(action: onConfirm)
                    .padding(.top, Theme.dateTimeCardButtonTopPadding)
                    .padding(.horizontal, Theme.dateCalendarCardHorizontalPadding)
                    .shadow(color: Color.black.opacity(Theme.dateCalendarCardStrokeOpacity), radius: Theme.dateCalendarCardButtonShadowRadius, x: 0, y: Theme.dateCalendarCardButtonShadowY)
            }
            .overlay(DateTimeWheelLinesOverlay())
        }
    }
}
