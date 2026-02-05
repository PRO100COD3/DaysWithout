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
        _viewModel = StateObject(wrappedValue: SupportViewModel())
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
            
            Button(action: viewModel.supportTapped) {
                Text(viewModel.buttonTitle)
                    .font(.custom("Onest", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 76/255, green: 61/255, blue: 41/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 255/255, green: 213/255, blue: 79/255))
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
        .onAppear {
            viewModel.onSupportTap = onSupportTap
            viewModel.onCloseAll = onCloseAll
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.5)
            .ignoresSafeArea()
        SupportView(onSupportTap: {}, onCloseAll: {})
            .padding(.horizontal, 40)
    }
}
