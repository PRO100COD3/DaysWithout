//
//  AddHabitView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 24.01.2026.
//

import SwiftUI

/// Экран добавления новой привычки
/// Модальное окно для ввода названия и выбора цвета
struct AddHabitView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel: AddHabitViewModel
    var onDismiss: () -> Void
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Initialization
    
    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: AddHabitViewModel(
            habitService: habitService,
            userStatusProvider: userStatusProvider
        ))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerView
                titleInputView
                    .padding(.top, Theme.addHabitTitleToInputSpacing)
                colorSelectionView
                    .padding(.top, Theme.addHabitInputToColorSpacing)
                    .padding(.horizontal, Theme.addHabitColorSectionHorizontalPadding)
                actionButtonsView
                    .padding(.top, Theme.addHabitColorToButtonsSpacing)
            }
            .padding(.horizontal, Theme.addHabitContentHorizontalPadding)
            .padding(.vertical, Theme.addHabitContentVerticalPadding)
            .background(Color.white.opacity(Theme.addHabitModalBackgroundOpacity))
            .cornerRadius(Theme.addHabitModalCornerRadius)
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
            .onAppear {
                viewModel.updateCardsInfo()
            }
            
            VStack {
                CharacterLimitAlertView(message: alertMessage, isPresented: $showAlert)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.horizontal, Theme.addHabitAlertHorizontalPadding)
                Spacer()
            }
            .animation(.spring(response: Theme.addHabitAlertAnimationResponse, dampingFraction: Theme.addHabitAlertAnimationDamping), value: showAlert)
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack(spacing: Theme.addHabitHeaderSpacing) {
            Text("Создать привычку")
                .font(.custom(Theme.headingFontName, size: Theme.addHabitHeaderFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.addHabitHeadingColor)
            Text("\(viewModel.currentCardsCount)/\(viewModel.maxCardsLimit)")
                .font(.custom(Theme.headingFontName, size: Theme.addHabitHeaderFontSize))
                .fontWeight(.medium)
                .foregroundColor(Theme.addHabitCounterColor)
        }
    }
    
    // MARK: - Title Input
    
    private var titleInputView: some View {
        VStack(alignment: .leading, spacing: Theme.addHabitInputInternalSpacing) {
            TextField(
                Theme.addHabitTitlePlaceholder,
                text: $viewModel.title
            )
            .multilineTextAlignment(.center)
            .font(.custom(Theme.headingFontName, size: Theme.addHabitInputFontSize))
            .fontWeight(.medium)
            .foregroundColor(Theme.addHabitInputTextColor)
            .padding(.horizontal, Theme.addHabitInputPaddingH)
            .padding(.vertical, Theme.addHabitInputPaddingV)
            .background(Theme.addHabitInputBackgroundColor)
            .overlay {
                RoundedRectangle(cornerRadius: Theme.addHabitInputCornerRadius)
                    .stroke(
                        showAlert ? Theme.addHabitInputBorderColorError : Theme.addHabitInputBorderColorNormal,
                        lineWidth: 1
                    )
            }
            .cornerRadius(Theme.addHabitInputCornerRadius)
            .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitInputShadowRadius, x: 0, y: Theme.addHabitInputShadowY)
        }
    }
    
    // MARK: - Color Selection
    
    private var colorSelectionView: some View {
        VStack(alignment: .center, spacing: Theme.addHabitColorSectionSpacing) {
            Text("Цвет карточки")
                .font(.custom(Theme.headingFontName, size: Theme.addHabitInputFontSize))
                .fontWeight(.semibold)
                .foregroundColor(Theme.addHabitHeadingColor)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: Theme.addHabitColorSectionSpacing),
                    GridItem(.flexible(), spacing: Theme.addHabitColorSectionSpacing),
                    GridItem(.flexible(), spacing: Theme.addHabitColorSectionSpacing),
                    GridItem(.flexible(), spacing: Theme.addHabitColorSectionSpacing)
                ],
                spacing: Theme.addHabitColorSectionSpacing
            ) {
                ForEach(1...8, id: \.self) { colorID in
                    colorCircle(for: colorID)
                }
            }
        }
    }
    
    private func colorCircle(for colorID: Int) -> some View {
        let colors = Theme.cardColor(for: colorID)
        return Button(action: {
            viewModel.selectedColorID = colorID
        }) {
            ZStack {
                LinearGradient(
                    colors: [colors.top, colors.bottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: Theme.addHabitColorCircleSize, height: Theme.addHabitColorCircleSize)
                .clipShape(Circle())
                if viewModel.selectedColorID == colorID {
                    RoundedRectangle(cornerRadius: Theme.addHabitColorCircleSelectedCornerRadius)
                        .stroke(
                            LinearGradient(colors: Theme.addHabitColorCircleSelectedStrokeColors, startPoint: .top, endPoint: .bottom),
                            lineWidth: 3
                        )
                        .frame(width: Theme.addHabitColorCircleSelectedSize, height: Theme.addHabitColorCircleSelectedSize)
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtonsView: some View {
        HStack(spacing: Theme.addHabitButtonsSpacing) {
            Button(action: { onDismiss() }) {
                Text("ОТМЕНА")
                    .font(.custom(Theme.headingFontName, size: Theme.addHabitButtonFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.addHabitCancelButtonTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.addHabitButtonHeight)
                    .background(Theme.addHabitCancelButtonBackgroundColor)
                    .cornerRadius(Theme.addHabitButtonCornerRadius)
                    .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitButtonShadowRadius, x: 0, y: Theme.addHabitButtonShadowY)
                    .overlay {
                        RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius)
                            .stroke(Theme.addHabitCancelButtonBorderColor, lineWidth: 1)
                    }
            }
            Button(action: { handleCreate() }) {
                Text("СОЗДАТЬ")
                    .font(.custom(Theme.headingFontName, size: Theme.addHabitButtonFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.addHabitCreateButtonTextColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.addHabitButtonHeight)
                    .background(Theme.addHabitCreateButtonBackgroundColor)
                    .cornerRadius(Theme.addHabitButtonCornerRadius)
                    .shadow(color: Theme.addHabitInputShadowColor, radius: Theme.addHabitButtonShadowRadius, x: 0, y: Theme.addHabitButtonShadowY)
                    .overlay {
                        RoundedRectangle(cornerRadius: Theme.addHabitButtonCornerRadius)
                            .stroke(Theme.addHabitCreateButtonBorderColor, lineWidth: 1)
                    }
            }
        }
    }
    
    // MARK: - Methods
    
    /// Обрабатывает нажатие "Создать": вызывает ViewModel, отображает результат через Theme
    private func handleCreate() {
        switch viewModel.attemptCreate() {
        case .success:
            dismissAlert()
            onDismiss()
        case .validationFailed(let reason):
            presentAlert(alertMessage(for: reason))
        case .serviceError(let error):
            if case .limitExceeded = error {
                dismissAlert()
                onDismiss()
            } else if case .titleTooLong(let maxLength) = error {
                presentAlert(Theme.addHabitAlertMaxCharacters(maxLength))
            } else {
                dismissAlert()
            }
        }
    }
    
    /// Маппинг причины валидации в строку для UI (Theme)
    private func alertMessage(for reason: AddHabitValidationReason) -> String {
        switch reason {
        case .emptyTitle:
            return Theme.addHabitAlertEnterTitle
        case .titleTooLong(let maxLength):
            return Theme.addHabitAlertMaxCharacters(maxLength)
        }
    }
    
    private func presentAlert(_ message: String) {
        alertMessage = message
        withAnimation(.spring(response: Theme.addHabitAlertAnimationResponse, dampingFraction: Theme.addHabitAlertAnimationDamping)) {
            showAlert = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Theme.addHabitAlertDisplayDuration) {
            dismissAlert()
        }
    }
    
    private func dismissAlert() {
        withAnimation(.spring(response: Theme.addHabitAlertAnimationResponse, dampingFraction: Theme.addHabitAlertAnimationDamping)) {
            showAlert = false
        }
    }
}

// MARK: - Preview

#Preview {
    let habitService = HabitService(
        storageService: UserDefaultsStorageService(),
        userStatusProvider: DefaultUserStatusProvider()
    )
    
    return AddHabitView(
        habitService: habitService,
        userStatusProvider: DefaultUserStatusProvider(),
        onDismiss: {}
    )
}
