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
                // Заголовок с счетчиком
                headerView
                
                // Поле ввода названия
                titleInputView
                    .padding(.top, 12)
                
                // Выбор цвета
                colorSelectionView
                    .padding(.top, 16)
                    .padding(.horizontal, 51)
                
                // Кнопки действий
                actionButtonsView
                    .padding(.top, 24)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 24)
            .background(Color.white.opacity(0.85))
            .cornerRadius(25)
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
            }
            .shadow(color: Color.black.opacity(0.12), radius: 25, x: 0, y: 10)
            .overlay {
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.05), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .offset(y: 4)
                    .blur(radius: 20)
                    .mask(RoundedRectangle(cornerRadius: 25))
            }
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
                .font(.custom("Onest", size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 34/255, green: 34/255, blue: 34/255))
            
            Text("\(viewModel.currentCardsCount)/\(viewModel.maxCardsLimit)")
                .font(.custom("Onest", size: 16))
                .fontWeight(.medium)
                .foregroundColor(Color(red: 43/255, green: 43/255, blue: 43/255))
        }
    }
    
    // MARK: - Title Input
    
    private var titleInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField(
                "Название",
                text: $viewModel.title
            )
            .multilineTextAlignment(.center)
            .font(.custom("Onest", size: 14))
            .fontWeight(.medium)
            .foregroundColor(Color(red: 156/255, green: 163/255, blue: 175/255))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        showAlert ? Color(red: 231/255, green: 84/255, blue: 84/255) : Color(red: 230/255, green: 230/255, blue: 230/255),
                        lineWidth: 1
                    )
            }
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
        }
    }
    
    // MARK: - Color Selection
    
    private var colorSelectionView: some View {
        VStack(alignment: .center, spacing: 16) {
            Text("Цвет карточки")
                .font(.custom(Theme.headingFontName, size: 14))
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 34/255, green: 34/255, blue: 34/255))
            
            // Сетка цветов (2 ряда по 4)
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
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
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                // Обводка для выбранного цвета
                if viewModel.selectedColorID == colorID {
                    RoundedRectangle(cornerRadius: 19)
                        .stroke(
                            LinearGradient(colors: [Color(red: 255/255, green: 255/255, blue: 255/255),Color(red: 240/255, green: 240/255, blue: 240/255)], startPoint: .top, endPoint: .bottom),
                            lineWidth: 3
                        )
                        .frame(width: 38, height: 38)
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
                    .font(.custom("Onest", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 110/255, green: 110/255, blue: 110/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 224/255, green: 224/255, blue: 224/255), lineWidth: 1)
                    }
            }
            
            // Кнопка "СОЗДАТЬ"
            Button(action: {
                handleCreate()
            }) {
                Text("СОЗДАТЬ")
                    .font(.custom("Onest", size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 58/255, green: 111/255, blue: 68/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(red: 216/255, green: 241/255, blue: 207/255))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 212/255, green: 232/255, blue: 217/255).opacity(0.9), lineWidth: 1)
                    }
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
