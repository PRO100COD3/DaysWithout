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
    
    /// Есть ли ошибка валидации (пустое поле или превышение лимита)
    private var hasValidationError: Bool {
        let trimmed = viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty || trimmed.count > 17
    }
    
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
                // Заголовок с счетчиком
                headerView
                
                // Поле ввода названия
                titleInputView
                    .padding(.top, 24)
                
                // Выбор цвета
                colorSelectionView
                    .padding(.top, 24)
                
                Spacer()
                
                // Кнопки действий
                actionButtonsView
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 20)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.25), radius: 30, x: 0, y: 10)
            .onAppear {
                viewModel.updateCardsInfo()
            }
            
            // Алерт поверх модального окна
            VStack {
                CharacterLimitAlertView(message: alertMessage, isPresented: $showAlert)
                    .transition(.move(edge: .top).combined(with: .opacity))
                
                Spacer()
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showAlert)
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack(spacing: 12) {
            Text("Создать привычку")
                .font(.custom(Theme.headingFontName, size: 20))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
            
            Text("\(viewModel.currentCardsCount)/\(viewModel.maxCardsLimit)")
                .font(.custom(Theme.headingFontName, size: 16))
                .fontWeight(.regular)
                .foregroundColor(Theme.mainDescriptionColor)
        }
    }
    
    // MARK: - Title Input
    
    private var titleInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(
                "Дни без алкоголя",
                text: $viewModel.title
            )
            .font(.custom(Theme.headingFontName, size: 14))
            .foregroundColor(Theme.mainHeadingColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        hasValidationError ? Color(red: 231/255, green: 84/255, blue: 84/255) : Color(red: 230/255, green: 230/255, blue: 230/255),
                        lineWidth: 1
                    )
            }
            .cornerRadius(10)
        }
    }
    
    // MARK: - Color Selection
    
    private var colorSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Цвет карточки")
                .font(.custom(Theme.headingFontName, size: 16))
                .fontWeight(.medium)
                .foregroundColor(Theme.mainHeadingColor)
            
            // Сетка цветов (2 ряда по 4)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
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
                // Градиентный фон
                LinearGradient(
                    colors: [colors.top, colors.bottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                
                // Обводка для выбранного цвета
                if viewModel.selectedColorID == colorID {
                    Circle()
                        .stroke(Color.black, lineWidth: 3)
                        .frame(width: 60, height: 60)
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtonsView: some View {
        HStack(spacing: 12) {
            // Кнопка "ОТМЕНА"
            Button(action: {
                onDismiss()
            }) {
                Text("ОТМЕНА")
                    .font(.custom(Theme.headingFontName, size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.mainHeadingColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(red: 247/255, green: 247/255, blue: 247/255))
                    .cornerRadius(12)
            }
            
            // Кнопка "СОЗДАТЬ"
            Button(action: {
                handleCreate()
            }) {
                Text("СОЗДАТЬ")
                    .font(.custom(Theme.headingFontName, size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Theme.addButtonColor)
                    .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Methods
    
    /// Обрабатывает создание карточки
    private func handleCreate() {
        let trimmed = viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Проверка на пустое поле
        if trimmed.isEmpty {
            showAlert(message: "Введите название")
            return
        }
        
        // Проверка на превышение лимита
        if trimmed.count > 17 {
            showAlert(message: "Максимальное кол-во символов - 17")
            return
        }
        
        // Создание карточки
        let result = viewModel.createCard()
        
        switch result {
        case .success:
            hideAlert()
            onDismiss()
        case .failure(let error):
            // Обработка других ошибок
            if case .limitExceeded = error {
                // Лимит карточек достигнут - можно показать другой алерт
                hideAlert()
            } else {
                // Для других ошибок показываем соответствующий алерт
                if trimmed.count > 17 {
                    showAlert(message: "Максимальное кол-во символов - 17")
                }
            }
        }
    }
    
    /// Показывает алерт с сообщением
    private func showAlert(message: String) {
        alertMessage = message
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showAlert = true
        }
        
        // Автоматически скрываем алерт через 3 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            hideAlert()
        }
    }
    
    /// Скрывает алерт
    private func hideAlert() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
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
