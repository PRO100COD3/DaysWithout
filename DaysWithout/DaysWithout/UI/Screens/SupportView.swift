//
//  SupportView.swift
//  DaysWithout
//

import SwiftUI

/// Экран «Поддержать разработчика». Отображает данные из ViewModel, не содержит бизнес-логики.
struct SupportView: View {
    let onSupportTap: () -> Void
    let onCloseAll: () -> Void
    
    @StateObject private var viewModel: SupportViewModel
    
    init(onSupportTap: @escaping () -> Void, onCloseAll: @escaping () -> Void) {
        self.onSupportTap = onSupportTap
        self.onCloseAll = onCloseAll
        _viewModel = StateObject(wrappedValue: SupportViewModel(onSupportTap: onSupportTap, onCloseAll: onCloseAll))
    }
    
    var body: some View {
        ModalCardView(strokeLineWidth: Theme.supportStrokeLineWidth) {
            VStack(alignment: .leading, spacing: Theme.supportContentStackSpacing) {
                Text(viewModel.title)
                    .font(.custom(Theme.headingFontName, size: Theme.supportTitleFontSize))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Theme.supportTitleColor)
                    .padding(.top, Theme.supportTitleTopPadding)
                    .padding(.horizontal, Theme.supportContentHorizontalPadding)

                Text(viewModel.message)
                    .font(.custom(Theme.headingFontName, size: Theme.supportMessageFontSize))
                    .fontWeight(.regular)
                    .foregroundColor(Theme.supportMessageColor)
                    .multilineTextAlignment(.leading)
                    .padding(.top, Theme.supportMessageTopPadding)
                    .padding(.horizontal, Theme.supportContentHorizontalPadding)

                Button(action: viewModel.supportTapped) {
                    Text(viewModel.buttonTitle)
                        .font(.custom(Theme.headingFontName, size: Theme.supportButtonFontSize))
                        .fontWeight(.medium)
                        .foregroundColor(Theme.supportButtonTextColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.supportButtonVerticalPadding)
                        .background(Theme.supportButtonBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.supportButtonCornerRadius))
                        .overlay {
                            RoundedRectangle(cornerRadius: Theme.supportButtonCornerRadius)
                                .stroke(Theme.supportButtonStrokeColor, lineWidth: Theme.supportStrokeLineWidth)
                        }
                }
                .padding(Theme.supportContentPadding)
                .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.supportButtonShadowRadius, x: 0, y: Theme.supportButtonShadowY)
                .pressAnimation()
            }
        }
        .overlay(alignment: .topTrailing) {
            ModalCloseButtonView(style: .support, action: viewModel.closeAll)
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(Theme.previewOverlayGrayOpacity)
            .ignoresSafeArea()
        SupportView(onSupportTap: {}, onCloseAll: {})
            .padding(.horizontal, Theme.screenPadding)
    }
}
