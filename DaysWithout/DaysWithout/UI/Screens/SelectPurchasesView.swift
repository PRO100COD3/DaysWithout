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
        VStack(spacing: 0) {
            headerView
                .padding(.top, 24)
            optionsList
                .padding(.top, 15)
                .padding(.horizontal, 24)
            subscribeButton
                .padding(.vertical, 24)
                .padding(.horizontal, 24)
        }
        .opacity(viewModel.isSuccessPresented ? 0 : 1)
        .allowsHitTesting(!viewModel.isSuccessPresented)
        .background(Color.white.opacity(Theme.addHabitModalBackgroundOpacity))
        .clipShape(RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius)
                .stroke(Theme.addHabitModalBorderColor, lineWidth: 1)
        }
        .shadow(color: Theme.addHabitModalShadowColor, radius: Theme.addHabitModalShadowRadius, x: 0, y: Theme.addHabitModalShadowY)
        .overlay {
            RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius)
                .fill(
                    LinearGradient(
                        colors: [Theme.addHabitModalInnerShadowColor, Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .offset(y: Theme.addHabitModalInnerShadowOffsetY)
                .blur(radius: Theme.addHabitModalInnerShadowBlur)
                .mask(RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius))
                .allowsHitTesting(false)
        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.isSuccessPresented {
                closeButton
            }
        }
        .opacity(viewModel.isSuccessPresented ? 0 : 1)
//        .overlay {
//            if viewModel.isSuccessPresented {
//                Color.black.opacity(0.3)
//                    .ignoresSafeArea()
//                    .onTapGesture { }
//            }
//        }
        .overlay {
            if viewModel.isSuccessPresented {
                SuccessPurchasesView(onCloseAll: viewModel.closeAll)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(viewModel.title)
                .font(.custom("Onest", size: 20))
                .fontWeight(.semibold)
                .foregroundColor(Theme.mainHeadingColor)
            Text(viewModel.descriptionText)
                .font(.custom("Onest", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color(red: 109/255, green: 109/255, blue: 109/255))
        }
        .frame(maxWidth: .infinity)
    }
    
    private var optionsList: some View {
        VStack(spacing: 12) {
            ForEach(Array(viewModel.options.enumerated()), id: \.element.id) { index, option in
                optionRow(option: option, index: index)
            }
        }
    }
    
    private func optionRow(option: SubscriptionOption, index: Int) -> some View {
        let isSelected = viewModel.selectedIndex == index
        return Button(action: { viewModel.selectOption(at: index) }) {
            HStack {
                Text(option.priceText)
                    .font(.custom("Onest", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : Color(red: 43/255, green: 43/255, blue: 43/255))
                Spacer()
                Text(option.periodTitle)
                    .font(.custom("Onest", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? Color(red: 232/255, green: 255/255, blue: 232/255) : Color(red: 43/255, green: 43/255, blue: 43/255).opacity(0.6))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Group {
                    if isSelected {
                        LinearGradient(
                            colors: [
                                Color(red: 133/255, green: 239/255, blue: 163/255),
                                Color(red: 91/255, green: 203/255, blue: 121/255)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    } else {
                        Color.white
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .pressAnimation()
    }
    
    private var subscribeButton: some View {
        Button(action: viewModel.subscribe) {
            Text(viewModel.subscribeButtonTitle)
                .font(.custom("Onest", size: 14))
                .fontWeight(.medium)
                .foregroundColor(Color(red: 58/255, green: 111/255, blue: 68/255))
                .frame(maxWidth: .infinity)
                .frame(height: Theme.addHabitButtonHeight)
                .background(
                    Color(red: 216/255, green: 241/255, blue: 207/255)
                )
                .clipShape(RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(red: 212/255, green: 232/255, blue: 217/255).opacity(0.9), lineWidth: 1)
                }
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        }
        .pressAnimation()
    }
    
    private var closeButton: some View {
        Button(action: viewModel.closeAll) {
            Image(systemName: "xmark")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Theme.mainHeadingColor)
                .frame(width: 36, height: 36)
        }
        .padding(10)
    }
}

#Preview {
    ZStack {
        Color.green.opacity(0.3)
            .ignoresSafeArea()
        SelectPurchasesView(onCloseAll: {})
            .padding(.horizontal, 32)
    }
}
