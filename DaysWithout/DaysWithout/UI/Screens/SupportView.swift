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
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.title)
                .font(.custom("Onest", size: 20))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(red: 34/255, green: 34/255, blue: 34/255))
                .padding(.top, 24)
                .padding(.horizontal, 24)
            
            Text(viewModel.message)
                .font(.custom("Onest", size: 16))
                .fontWeight(.regular)
                .foregroundColor(Color(red: 109/255, green: 109/255, blue: 109/255))
                .multilineTextAlignment(.leading)
                .padding(.top, 12)
                .padding(.horizontal, 24)
            
            Button(action: viewModel.supportTapped) {
                Text(viewModel.buttonTitle)
                    .font(.custom("Onest", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 173/255, green: 133/255, blue: 17/255))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 255/255, green: 211/255, blue: 34/255).opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 248/255, green: 224/255, blue: 130/255), lineWidth: 1)
                    }
            }
            .padding(24)
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
        Color.gray.opacity(0.5)
            .ignoresSafeArea()
        SupportView(onSupportTap: {}, onCloseAll: {})
            .padding(.horizontal, 23)
    }
}
