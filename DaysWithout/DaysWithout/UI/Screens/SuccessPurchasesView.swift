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
        VStack(spacing: 0) {
            Text(viewModel.title)
                .font(.custom("Onest", size: 20))
                .fontWeight(.semibold)
                .foregroundColor(Theme.mainHeadingColor)
                .padding(.top, 24)
            
            Text(viewModel.message)
                .font(.custom("Onest", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainDescriptionColor)
                .multilineTextAlignment(.center)
                .padding(.top, 12)
                .padding(.horizontal, 24)
            
            Button(action: viewModel.closeAll) {
                Text(viewModel.buttonTitle)
                    .font(.custom("Onest", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 58/255, green: 111/255, blue: 68/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 216/255, green: 241/255, blue: 207/255))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 24)
            .shadow(color: Theme.addHabitModalShadowColor, radius: 8, x: 0, y: 4)
            .pressAnimation()
        }
        .background(Color.white.opacity(Theme.addHabitModalBackgroundOpacity))
        .clipShape(RoundedRectangle(cornerRadius: Theme.addHabitModalCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: 25)
                .stroke(Theme.addHabitModalBorderColor, lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.12), radius: 25, x: 0, y: 10)
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
            Button(action: viewModel.closeAll) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
                    .frame(width: 36, height: 36)
            }
            .padding(10)
        }
    }
}

#Preview {
    ZStack {
        Color.white
            .ignoresSafeArea()
        SuccessPurchasesView(onCloseAll: {})
            .padding(.horizontal, 40)
    }
}
