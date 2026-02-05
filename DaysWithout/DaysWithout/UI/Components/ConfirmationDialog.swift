//
//  ConfirmationDialog.swift
//  BadHabits
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import SwiftUI

struct ConfirmationDialog: View {
    @Binding var isPresented: Bool
    
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        if isPresented {
            VStack(spacing: Theme.dialogSpacing) {
                HStack {
                    Text("Подтвердите удаление")
                        .font(.custom(Theme.headingFontName, size: Theme.dialogTitleFontSize))
                        .fontWeight(.bold)
                        .foregroundColor(Theme.dialogTitleColor)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Вы уверены, что хотите \nудалить эту карточку?")
                        .font(.custom(Theme.headingFontName, size: Theme.dialogBodyFontSize))
                        .fontWeight(.regular)
                        .foregroundColor(Theme.dialogBodyColor)
                        .lineLimit(2)
                    
                    Spacer()
                }
                
                HStack(spacing: Theme.dialogSpacing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: Theme.dialogAnimationDuration)) {
                            onCancel()
                        }
                    }) {
                        Text("ОТМЕНА")
                            .font(.custom(Theme.headingFontName, size: Theme.dialogButtonFontSize))
                            .fontWeight(.medium)
                            .foregroundColor(Theme.dialogCancelButtonTextColor)
                            .frame(maxWidth: .infinity, maxHeight: Theme.dialogButtonHeight)
                            .background {
                                RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(Theme.dialogButtonShadowOpacity), radius: Theme.dialogButtonShadowRadius, x: 0, y: Theme.dialogButtonShadowY)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                                            .stroke(Theme.dialogCancelButtonBorderColor, lineWidth: 1)
                                    }
                            }
                    }
                    .pressAnimation()
                    .padding(.top, Theme.dialogSpacing)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: Theme.dialogAnimationDuration)) {
                            onConfirm()
                        }
                    }) {
                        Text("УДАЛИТЬ")
                            .font(.custom(Theme.headingFontName, size: Theme.dialogButtonFontSize))
                            .fontWeight(.medium)
                            .foregroundColor(Theme.dialogRedButtonTextColor)
                            .frame(maxWidth: .infinity, maxHeight: Theme.dialogButtonHeight)
                            .background {
                                RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                                    .fill(Theme.redButton)
                                    .shadow(color: Color.black.opacity(Theme.dialogButtonShadowOpacity), radius: Theme.dialogButtonShadowRadius, x: 0, y: Theme.dialogButtonShadowY)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                                            .stroke(Theme.dialogRedButtonBorderColor, lineWidth: 1)
                                    }
                            }
                    }
                    .pressAnimation()
                    .padding(.top, Theme.dialogSpacing)
                }
            }
            .padding(Theme.dialogPadding)
            .background {
                RoundedRectangle(cornerRadius: Theme.dialogCornerRadius)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Theme.dialogGradientTop,
                                Theme.dialogGradientBottom
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.black.opacity(Theme.dialogShadowOpacity), radius: Theme.dialogShadowRadius, x: 0, y: Theme.dialogShadowY)
            }
            .padding(.horizontal, Theme.dialogHorizontalPadding)
            .opacity(isPresented ? Theme.dialogPresentedOpacity : Theme.dialogDismissedOpacity)
            .scaleEffect(isPresented ? Theme.dialogPresentedScale : Theme.dialogDismissedScale)
        }
    }
}
