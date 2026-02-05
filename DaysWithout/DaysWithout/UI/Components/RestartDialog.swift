//
//  RestartDialog.swift
//  BadHabits
//
//  Created by Вадим Дзюба on 19.01.2026.
//

import SwiftUI

struct RestartDialog: View {
    @Binding var isPresented: Bool
    @Binding var reason: String
    
    let characterLimit: Int
    let onConfirm: () -> Void
    let onCancel: () -> Void
    let onCharacterLimitExceeded: () -> Void
    
    @State private var textEditorHeight: CGFloat = Theme.restartDialogTextEditorMinHeight
    @State private var wasOverLimit: Bool = false
    @State private var containerWidth: CGFloat = 0
    
    private var font: UIFont {
        let descriptor = UIFontDescriptor(name: Theme.headingFontName, size: Theme.restartDialogTextEditorFontSize)
            .addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]])
        return UIFont(descriptor: descriptor, size: Theme.restartDialogTextEditorFontSize)
    }
    private let minHeight: CGFloat = Theme.restartDialogTextEditorMinHeight
    private let maxHeight: CGFloat = Theme.restartDialogTextEditorMaxHeight
    
    private var isOverLimit: Bool {
        reason.count > characterLimit
    }
    
    var body: some View {
        if isPresented {
            VStack {
                HStack(spacing: Theme.dialogSpacing) {
                    Text("Рестарт")
                        .font(.custom(Theme.headingFontName, size: Theme.dialogTitleFontSize))
                        .fontWeight(.bold)
                        .foregroundColor(Theme.dialogTitleColor)
                    
                    Spacer()
                }
                
                ZStack(alignment: .topLeading) {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                            .fill(Theme.restartDialogInputBackgroundColor)
                            .shadow(color: Color.black.opacity(Theme.dialogButtonShadowOpacity), radius: Theme.dialogButtonShadowRadius, x: 0, y: Theme.dialogButtonShadowY)
                            .overlay {
                                RoundedRectangle(cornerRadius: Theme.dialogButtonCornerRadius)
                                    .stroke(isOverLimit ? Theme.redButton : Theme.restartDialogInputBorderColorNormal, lineWidth: 1)
                            }
                            .onAppear {
                                containerWidth = geometry.size.width
                                calculateHeight(for: reason)
                            }
                            .onChange(of: geometry.size.width) { newWidth in
                                containerWidth = newWidth
                                calculateHeight(for: reason)
                            }
                    }
                    
                    TextEditor(text: $reason)
                        .font(.custom(Theme.headingFontName, size: Theme.restartDialogTextEditorFontSize))
                        .fontWeight(.medium)
                        .foregroundColor(Theme.restartDialogInputPlaceholderColor)
                        .scrollContentBackground(.hidden)
                        .padding(.horizontal, Theme.restartDialogInputPaddingH)
                        .padding(.vertical, Theme.restartDialogInputPaddingV)
                        .padding(.trailing, Theme.restartDialogInputPaddingTrailing)
                    
                    if reason.isEmpty {
                        Text("Причина")
                            .font(.custom(Theme.headingFontName, size: Theme.restartDialogTextEditorFontSize))
                            .fontWeight(.medium)
                            .foregroundColor(Theme.restartDialogInputPlaceholderColor)
                            .padding(.horizontal, Theme.restartDialogPlaceholderPaddingH)
                            .padding(.vertical, Theme.restartDialogPlaceholderPaddingV)
                            .allowsHitTesting(false)
                    }
                }
                .frame(height: textEditorHeight)
                .onChange(of: reason) { newValue in
                    let maxCharacters = characterLimit + 1
                    if newValue.count > maxCharacters {
                        reason = String(newValue.prefix(maxCharacters))
                        return
                    }
                    
                    calculateHeight(for: newValue)
                    
                    let currentlyOverLimit = newValue.count > characterLimit
                    if currentlyOverLimit && !wasOverLimit {
                        onCharacterLimitExceeded()
                    }
                    wasOverLimit = currentlyOverLimit
                }
                .onAppear {
                    wasOverLimit = reason.count > characterLimit
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
                        Text("РЕСТАРТ")
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
    
    private func calculateHeight(for text: String) {
        guard containerWidth > 0 else { return }
        
        let textWidth = containerWidth - Theme.restartDialogCalculateWidthInset - Theme.restartDialogCalculateVerticalInset
        
        let textToMeasure = text.isEmpty ? " " : text
        let attributedString = NSAttributedString(
            string: textToMeasure,
            attributes: [.font: font]
        )
        
        let boundingRect = attributedString.boundingRect(
            with: CGSize(width: textWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let calculatedHeight = ceil(boundingRect.height) + Theme.restartDialogCalculateVerticalInset + Theme.restartDialogCalculateBottomInset
        
        withAnimation(.easeInOut(duration: Theme.restartDialogHeightAnimationDuration)) {
            textEditorHeight = min(max(calculatedHeight, minHeight), maxHeight)
        }
    }
}
