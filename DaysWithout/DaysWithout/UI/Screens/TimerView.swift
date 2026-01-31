//
//  TimerView.swift
//  DaysWithout
//

import SwiftUI

/// Экран таймера для карточки привычки. Отображает данные из ViewModel, не содержит бизнес-логики.
struct TimerView: View {
    let card: HabitCard
    let habitService: HabitServiceProtocol
    let onDismiss: () -> Void
    
    @StateObject private var viewModel: TimerViewModel
    
    init(card: HabitCard, habitService: HabitServiceProtocol, onDismiss: @escaping () -> Void) {
        self.card = card
        self.habitService = habitService
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: TimerViewModel(card: card, habitService: habitService))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 127/255, green: 238/255, blue: 210/255),
                        Color(red: 53/255, green: 192/255, blue: 164/255)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button(action: onDismiss) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.18))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .black))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 44, height: 44)
                        .padding(.top, 3)
                        .padding(.trailing, 14)
                        .pressAnimation()
                    }
                    
                    TextField("", text: $viewModel.text)
                        .font(.custom(Theme.headingFontName, size: 24))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .padding(.top, 46)
                        .padding(.horizontal, 20)
                        .onChange(of: viewModel.text) { newValue in
                            viewModel.handleTextChange(newValue)
                        }
                                        
                    CircularProgressView(
                        progress: viewModel.progress,
                        days: viewModel.days,
                        timeString: viewModel.timeString
                    )
                    .padding(.top, 53)
                    
                    Button(action: {
                        if viewModel.shouldShowRestart {
                            viewModel.showRestartDialog()
                        } else {
                            viewModel.startTimer()
                        }
                    }) {
                        Text(viewModel.shouldShowRestart ? "РЕСТАРТ" : "СТАРТ")
                            .font(.custom("Onest", size: 20))
                            .fontWeight(.regular)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 1, green: 1, blue: 1))
                                    .opacity(0.3)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                                    }
                                    .frame(width: 115, height: 37)
                                    
                            }
                    }
                    .frame(width: 115, height: 37)
                    .padding(.top, 68)
                    .pressAnimation()
                    
                    HStack(spacing: 80) {
                        Button(action: {
                            // Действие для первой кнопки
                        }) {
                            Image("book")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .pressAnimation()
                        
                        Button(action: {
                            // Действие для второй кнопки
                        }) {
                            Image("time")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                
                        }
                        .pressAnimation()
                        
                        Button(action: {
                            viewModel.showCloseDialog()
                        }) {
                            Image("trash")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                        }
                        .pressAnimation()
                    }
                    .padding(.top, 57)
                    .padding([.leading, .trailing], 67)
                    
                    Spacer()
                }
            }
            .blur(radius: viewModel.shouldShowRestartDialog || viewModel.shouldShowCloseDialog ? 8 : 0)
            .overlay {
                if viewModel.shouldShowRestartDialog || viewModel.shouldShowCloseDialog {
                    Color.black.opacity(0.3)
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
                        message: Theme.addHabitAlertMaxCharacters(viewModel.maxLength),
                        isPresented: $viewModel.showLimitAlert
                    )
                    .padding(24)
                }
            }
            .overlay(alignment: .top) {
                if viewModel.showRestartReasonLimitAlert {
                    CharacterLimitAlertView(
                        message: Theme.addHabitAlertMaxCharacters(viewModel.restartReasonMaxLength),
                        isPresented: $viewModel.showRestartReasonLimitAlert
                    )
                    .padding(24)
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
                .padding(.top, 238)
            }
            .overlay(alignment: .top) {
                ConfirmationDialog(
                    isPresented: $viewModel.shouldShowCloseDialog,
                    onConfirm: {
                        viewModel.confirmClose()
                        onDismiss()
                    },
                    onCancel: {
                        viewModel.cancelClose()
                    }
                )
                .padding(.top, 270)
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
    return TimerView(card: card, habitService: habitService, onDismiss: {})
}
