//
//  SelectPurchasesView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 05.02.2026.
//

import SwiftUI

/// Экран выбора подписки Премиум. Отображает данные из ViewModel, не содержит бизнес-логики.
struct SelectPurchasesView: View {
    let onCloseAll: () -> Void

    @StateObject private var viewModel: SelectPurchasesViewModel

    init(onCloseAll: @escaping () -> Void) {
        self.onCloseAll = onCloseAll
        _viewModel = StateObject(wrappedValue: SelectPurchasesViewModel(onCloseAll: onCloseAll))
    }

    var body: some View {
        ModalCardView(strokeLineWidth: Theme.selectPurchasesStrokeLineWidth) {
            VStack(spacing: Theme.selectPurchasesContentStackSpacing) {
                SelectPurchasesHeaderView(
                    title: viewModel.title,
                    descriptionText: viewModel.descriptionText
                )
                .padding(.top, Theme.selectPurchasesHeaderTopPadding)
                SelectPurchasesOptionsListView(
                    options: viewModel.options,
                    selectedIndex: viewModel.selectedIndex,
                    onSelect: viewModel.selectOption(at:)
                )
                .padding(.top, Theme.selectPurchasesOptionsTopPadding)
                .padding(.horizontal, Theme.supportContentHorizontalPadding)
                SelectPurchasesSubscribeButtonView(
                    title: viewModel.subscribeButtonTitle,
                    action: viewModel.subscribe
                )
                .padding(.vertical, Theme.selectPurchasesBottomVerticalPadding)
                .padding(.horizontal, Theme.supportContentHorizontalPadding)
            }
        }
        .opacity(viewModel.isSuccessPresented ? Theme.selectPurchasesHiddenOpacity : Theme.selectPurchasesVisibleOpacity)
        .allowsHitTesting(!viewModel.isSuccessPresented)
        .overlay(alignment: .topTrailing) {
            if !viewModel.isSuccessPresented {
                ModalCloseButtonView(style: .selectPurchases, action: viewModel.closeAll)
            }
        }
        .overlay {
            if viewModel.isSuccessPresented {
                SuccessPurchasesView(onCloseAll: viewModel.closeAll)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.green.opacity(Theme.previewOverlayGreenOpacity)
            .ignoresSafeArea()
        SelectPurchasesView(onCloseAll: {})
            .padding(.horizontal, Theme.screenPadding)
    }
}
