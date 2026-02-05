//
//  TimerView.swift
//  DaysWithout
//

import SwiftUI

/// Экран таймера для карточки привычки. Отображает данные из ViewModel, не содержит бизнес-логики.
struct TimerView: View {
    let card: HabitCard
    let habitService: HabitServiceProtocol
    let restartHistoryService: RestartHistoryServiceProtocol
    let onDismiss: () -> Void
    
    @StateObject private var viewModel: TimerViewModel
    
    init(card: HabitCard, habitService: HabitServiceProtocol, restartHistoryService: RestartHistoryServiceProtocol, onDismiss: @escaping () -> Void) {
        self.card = card
        self.habitService = habitService
        self.restartHistoryService = restartHistoryService
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: TimerViewModel(
            card: card,
            habitService: habitService,
            restartHistoryService: restartHistoryService,
            onClose: onDismiss,
            messageForMaxLength: { Theme.addHabitAlertMaxCharacters($0) },
            messageForRestartReasonLimit: { Theme.addHabitAlertMaxCharacters($0) }
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Theme.timerGradientTop,
                        Theme.timerGradientBottom
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                VStack(spacing: Theme.timerContentStackSpacing) {
                    HStack {
                        Spacer()
                        Button(action: onDismiss) {
                            ZStack {
                                Circle()
                                    .fill(Theme.timerCloseCircleColor.opacity(Theme.timerCloseCircleOpacity))
                                    .frame(width: Theme.timerCloseCircleSize, height: Theme.timerCloseCircleSize)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: Theme.timerCloseButtonFontSize, weight: .black))
                                    .foregroundColor(Theme.timerPrimaryTextColor)
                            }
                        }
                        .frame(width: Theme.timerCloseButtonFrameSize, height: Theme.timerCloseButtonFrameSize)
                        .padding(.top, Theme.timerCloseButtonTopPadding)
                        .padding(.trailing, Theme.timerCloseButtonTrailingPadding)
                        .pressAnimation()
                    }
                    
                    TextField("", text: $viewModel.text)
                        .font(.custom(Theme.headingFontName, size: Theme.timerTextFieldFontSize))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(Theme.timerPrimaryTextColor)
                        .padding(.top, Theme.timerTextFieldTopPadding)
                        .padding(.horizontal, Theme.timerTextFieldHorizontalPadding)
                        .onChange(of: viewModel.text) { newValue in
                            viewModel.handleTextChange(newValue)
                        }
                                        
                    CircularProgressView(
                        progress: viewModel.progress,
                        days: viewModel.days,
                        timeString: viewModel.timeString
                    )
                    .padding(.top, Theme.timerProgressTopPadding)
                    
                    Button(action: viewModel.handleMainButtonTap) {
                        Text("РЕСТАРТ")
                            .font(.custom(Theme.headingFontName, size: Theme.timerRestartButtonFontSize))
                            .fontWeight(.regular)
                            .foregroundColor(Theme.timerPrimaryTextColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Theme.timerRestartButtonVerticalPadding)
                            .background {
                                RoundedRectangle(cornerRadius: Theme.timerRestartButtonCornerRadius)
                                    .fill(Theme.timerRestartButtonBackgroundColor)
                                    .opacity(Theme.timerRestartButtonBackgroundOpacity)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: Theme.timerRestartButtonCornerRadius)
                                            .stroke(Theme.timerPrimaryTextColor.opacity(Theme.timerRestartButtonStrokeOpacity), lineWidth: Theme.timerRestartButtonStrokeLineWidth)
                                    }
                                    .frame(width: Theme.timerRestartButtonWidth, height: Theme.timerRestartButtonHeight)
                                    
                            }
                    }
                    .frame(width: Theme.timerRestartButtonWidth, height: Theme.timerRestartButtonHeight)
                    .padding(.top, Theme.timerRestartButtonTopPadding)
                    .pressAnimation()
                    
                    HStack(spacing: Theme.timerActionsSpacing) {
                        Button(action: viewModel.presentStory) {
                            Image("book")
                                .font(.system(size: Theme.timerActionIconFontSize))
                                .foregroundColor(Theme.timerPrimaryTextColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.timerActionVerticalPadding)
                        }
                        .pressAnimation()
                        
                        Button(action: viewModel.presentDatePicker) {
                            Image("time")
                                .font(.system(size: Theme.timerActionIconFontSize))
                                .foregroundColor(Theme.timerPrimaryTextColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.timerActionVerticalPadding)
                                
                        }
                        .pressAnimation()
                        
                        Button(action: {
                            viewModel.showCloseDialog()
                        }) {
                            Image("trash")
                                .font(.system(size: Theme.timerActionIconFontSize))
                                .foregroundColor(Theme.timerPrimaryTextColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, Theme.timerActionVerticalPadding)
                        }
                        .pressAnimation()
                    }
                    .padding(.top, Theme.timerActionsTopPadding)
                    .padding([.leading, .trailing], Theme.timerActionsHorizontalPadding)
                    
                    Spacer()
                }
            }
            .blur(radius: viewModel.shouldShowRestartDialog || viewModel.shouldShowCloseDialog ? Theme.timerOverlayBlurRadius : 0)
            .overlay {
                if viewModel.shouldShowRestartDialog || viewModel.shouldShowCloseDialog {
                    Color.black.opacity(Theme.timerOverlayOpacity)
                        .ignoresSafeArea()
                }
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        hideKeyboard()
                    }
            )
            .overlay(alignment: .top) {
                if viewModel.showLimitAlert {
                    CharacterLimitAlertView(
                        message: viewModel.characterLimitAlertMessage,
                        isPresented: $viewModel.showLimitAlert
                    )
                    .padding(Theme.timerAlertPadding)
                }
            }
            .overlay(alignment: .top) {
                if viewModel.showRestartReasonLimitAlert {
                    CharacterLimitAlertView(
                        message: viewModel.restartReasonLimitAlertMessage,
                        isPresented: $viewModel.showRestartReasonLimitAlert
                    )
                    .padding(Theme.timerAlertPadding)
                }
            }
            .overlay(alignment: .top) {
                RestartDialog(
                    isPresented: $viewModel.shouldShowRestartDialog,
                    reason: $viewModel.restartReason,
                    characterLimit: viewModel.restartReasonMaxLength,
                    onConfirm: {
                        viewModel.confirmRestart()
                    },
                    onCancel: {
                        viewModel.cancelRestart()
                    },
                    onCharacterLimitExceeded: {
                        viewModel.showRestartReasonCharacterLimitAlert()
                    }
                )
                .padding(.top, Theme.timerRestartDialogTopPadding)
            }
            .overlay(alignment: .top) {
                ConfirmationDialog(
                    isPresented: $viewModel.shouldShowCloseDialog,
                    onConfirm: viewModel.confirmClose,
                    onCancel: viewModel.cancelClose
                )
                .padding(.top, Theme.timerCloseDialogTopPadding)
            }
            .fullScreenCover(isPresented: $viewModel.isStoryPresented) {
                StoryView(
                    card: viewModel.cardForStory,
                    restartHistoryService: viewModel.restartHistoryServiceForStory,
                    onDismiss: viewModel.dismissStory
                )
            }
            .fullScreenCover(isPresented: $viewModel.isDatePickerPresented) {
                DateView(
                    initialDate: viewModel.initialDateForDatePicker,
                    onConfirm: viewModel.applyNewStartDateAndDismissPicker,
                    onDismiss: viewModel.dismissDatePicker
                )
            }
        }
    }
}

#Preview {
    let card = HabitCard(
        title: "Дни без кофе",
        startDate: Date(),
        colorID: 1
    )
    let habitService = HabitService(
        storageService: UserDefaultsStorageService(),
        userStatusProvider: DefaultUserStatusProvider()
    )
    let restartHistoryService = RestartHistoryService()
    return TimerView(card: card, habitService: habitService, restartHistoryService: restartHistoryService, onDismiss: {})
}
