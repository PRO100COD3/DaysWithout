//
//  SuccessPurchasesView.swift
//  DaysWithout
//

import SwiftUI

/// Экран успешного оформления подписки. Отображает данные из ViewModel, не содержит бизнес-логики.
struct SuccessPurchasesView: View {
    let onCloseAll: () -> Void
    
    @StateObject private var viewModel: SuccessPurchasesViewModel
    
    init(onCloseAll: @escaping () -> Void) {
        self.onCloseAll = onCloseAll
        _viewModel = StateObject(wrappedValue: SuccessPurchasesViewModel(onCloseAll: onCloseAll))
    }
    
    var body: some View {
        ModalCardView(strokeLineWidth: Theme.successModalStrokeLineWidth) {
            VStack(spacing: Theme.successContentStackSpacing) {
                Text(viewModel.title)
                    .font(.custom(Theme.headingFontName, size: Theme.successTitleFontSize))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.mainHeadingColor)
                    .padding(.top, Theme.successTitleTopPadding)

                Text(viewModel.message)
                    .font(.custom(Theme.headingFontName, size: Theme.successMessageFontSize))
                    .fontWeight(.regular)
                    .foregroundColor(Theme.mainDescriptionColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, Theme.successMessageTopPadding)
                    .padding(.horizontal, Theme.successMessageHorizontalPadding)

                Button(action: viewModel.closeAll) {
                    Text(viewModel.buttonTitle)
                        .font(.custom(Theme.headingFontName, size: Theme.successButtonFontSize))
                        .fontWeight(.medium)
                        .foregroundColor(Theme.addHabitCreateButtonTextColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: Theme.successButtonHeight)
                        .background(Theme.addHabitCreateButtonBackgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.successButtonCornerRadius))
                }
                .padding(.horizontal, Theme.successMessageHorizontalPadding)
                .padding(.vertical, Theme.successContentVerticalPadding)
                .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.successButtonShadowRadius, x: 0, y: Theme.successButtonShadowY)
                .pressAnimation()
            }
        }
        .overlay(alignment: .topTrailing) {
            ModalCloseButtonView(style: .success, action: viewModel.closeAll)
        }
    }
}

#Preview {
    ZStack {
        Theme.previewBackgroundWhite
            .ignoresSafeArea()
        SuccessPurchasesView(onCloseAll: {})
            .padding(.horizontal, Theme.screenPadding)
    }
}
