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

    // MARK: - Initialization

    init(
        habitService: HabitServiceProtocol,
        userStatusProvider: UserStatusProvider,
        onDismiss: @escaping () -> Void = {}
    ) {
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: AddHabitViewModel(
            habitService: habitService,
            userStatusProvider: userStatusProvider,
            onDismiss: onDismiss,
            alertDisplayDuration: Theme.addHabitAlertDisplayDuration,
            alertMessageForValidation: { reason in
                switch reason {
                case .emptyTitle:
                    return Theme.addHabitAlertEnterTitle
                case .titleTooLong(let maxLength):
                    return Theme.addHabitAlertMaxCharacters(maxLength)
                }
            },
            alertMessageForServiceError: { error in
                switch error {
                case .titleTooLong(let maxLength):
                    return Theme.addHabitAlertMaxCharacters(maxLength)
                default:
                    return nil
                }
            }
        ))
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            ModalCardView(strokeLineWidth: Theme.addHabitModalStrokeLineWidth) {
                VStack(spacing: Theme.addHabitContentStackSpacing) {
                    AddHabitHeaderView(
                        currentCount: viewModel.currentCardsCount,
                        maxCount: viewModel.maxCardsLimit
                    )
                    AddHabitTitleInputView(
                        placeholder: Theme.addHabitTitlePlaceholder,
                        text: $viewModel.title,
                        hasError: viewModel.alertMessage != nil || viewModel.showCharacterLimitAlert
                    )
                    .padding(.top, Theme.addHabitTitleToInputSpacing)
                    .onChange(of: viewModel.title) { newValue in
                        viewModel.handleTitleChange(newValue)
                    }
                    AddHabitColorSelectionView(selectedColorID: $viewModel.selectedColorID)
                        .padding(.top, Theme.addHabitInputToColorSpacing)
                        .padding(.horizontal, Theme.addHabitColorSectionHorizontalPadding)
                    AddHabitActionButtonsView(
                        onCancel: onDismiss,
                        onCreate: { viewModel.attemptCreate() }
                    )
                    .padding(.top, Theme.addHabitColorToButtonsSpacing)
                }
                .padding(.horizontal, Theme.addHabitContentHorizontalPadding)
                .padding(.vertical, Theme.addHabitContentVerticalPadding)
                .onAppear {
                    viewModel.onAppear()
                }
            }
            
            VStack {
                if viewModel.showCharacterLimitAlert {
                    CharacterLimitAlertView(
                        message: viewModel.characterLimitAlertMessage,
                        isPresented: $viewModel.showCharacterLimitAlert
                    )
                    .padding(.horizontal, Theme.addHabitAlertHorizontalPaddingAlert)
                } else if let message = viewModel.alertMessage {
                    CharacterLimitAlertView(
                        message: message,
                        isPresented: Binding(
                            get: { viewModel.alertMessage != nil },
                            set: { if !$0 { viewModel.clearAlert() } }
                        )
                    )
                    .padding(.horizontal, Theme.addHabitAlertHorizontalPaddingAlert)
                }
                Spacer()
            }
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
    ).padding(.horizontal, 46)
}
