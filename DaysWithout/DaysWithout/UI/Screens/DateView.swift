//
//  DateView.swift
//  DaysWithout
//

import SwiftUI

/// Экран поочерёдного выбора даты (календарь) и времени (циферблат), затем сохранение новой даты начала.
struct DateView: View {
    let initialDate: Date
    let onConfirm: (Date) -> Void
    let onDismiss: () -> Void
    
    @StateObject private var viewModel: DateViewModel
    
    init(initialDate: Date, onConfirm: @escaping (Date) -> Void, onDismiss: @escaping () -> Void) {
        self.initialDate = initialDate
        self.onConfirm = onConfirm
        self.onDismiss = onDismiss
        _viewModel = StateObject(wrappedValue: DateViewModel(initialDate: initialDate))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            contentView
        }
        .background(Theme.backgroundColor[1].ignoresSafeArea())
        .onAppear {
            viewModel.onConfirm = { [onConfirm] date in
                onConfirm(date)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                if viewModel.canGoBack {
                    viewModel.goBack()
                } else {
                    onDismiss()
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
            }
            .frame(width: 44, height: 44)
            Spacer()
            Text(viewModel.title)
                .font(.custom(Theme.headingFontName, size: Theme.mainHeadingFontSize))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
            Spacer()
            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(Color.white)
        .overlay(alignment: .bottom) {
            Divider()
                .background(Theme.DeviderColor)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch viewModel.step {
        case .date:
            calendarCard
        case .time:
            timeCard
        }
    }
    
    private var calendarCard: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack {
                    Button(action: viewModel.previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.addButtonColor)
                    }
                    Spacer()
                    Text(viewModel.monthYearTitle)
                        .font(.custom(Theme.headingFontName, size: 17))
                        .fontWeight(.medium)
                        .foregroundColor(Theme.mainHeadingColor)
                    Spacer()
                    Button(action: viewModel.nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Theme.addButtonColor)
                    }
                }
                .padding(.horizontal, 4)
                
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                        Text(symbol)
                            .font(.custom(Theme.cardFontName, size: 12))
                            .foregroundColor(Theme.mainDescriptionColor)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let days = viewModel.daysInMonth()
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                        if let date = day {
                            let selected = viewModel.isSelectedDay(date)
                            let inMonth = viewModel.isCurrentMonth(date)
                            Button(action: { viewModel.selectDay(date) }) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.custom(Theme.headingFontName, size: 16))
                                    .foregroundColor(selected ? .white : (inMonth ? Theme.mainHeadingColor : Theme.mainDescriptionColor))
                                    .frame(width: 36, height: 36)
                                    .background(
                                        Circle()
                                            .fill(selected ? Theme.addButtonColor : Color.clear)
                                    )
                            }
                            .buttonStyle(.plain)
                        } else {
                            Color.clear
                                .frame(width: 36, height: 36)
                        }
                    }
                }
            }
            .padding(20)
            createButton
        }
        .padding(Theme.screenPadding)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .shadow(color: Theme.cardShadowColor, radius: Theme.cardShadowRadius, x: Theme.cardShadowX, y: Theme.cardShadowY)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
    }
    
    private var timeCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24) {
                timeWheel(title: "Часы", range: 0..<24, value: Binding(
                    get: { viewModel.selectedHour },
                    set: { viewModel.selectedHour = $0 }
                ))
                timeWheel(title: "Минуты", range: 0..<60, value: Binding(
                    get: { viewModel.selectedMinute },
                    set: { viewModel.selectedMinute = $0 }
                ))
            }
            .padding(.vertical, 24)
            createButton
        }
        .padding(Theme.screenPadding)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .shadow(color: Theme.cardShadowColor, radius: Theme.cardShadowRadius, x: Theme.cardShadowX, y: Theme.cardShadowY)
        .padding(.horizontal, Theme.screenPadding)
        .padding(.top, 20)
    }
    
    private func timeWheel(title: String, range: Range<Int>, value: Binding<Int>) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom(Theme.cardFontName, size: Theme.cardSmallTextFontSize))
                .foregroundColor(Theme.mainDescriptionColor)
            Picker("", selection: value) {
                ForEach(range, id: \.self) { n in
                    Text("\(n)")
                        .tag(n)
                }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
        }
        .frame(maxWidth: .infinity)
    }
    
    private var createButton: some View {
        Button(action: viewModel.confirmCurrentStep) {
            Text("СОЗДАТЬ")
                .font(.custom(Theme.headingFontName, size: 16))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.addButtonColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .pressAnimation()
    }
}

#Preview {
    DateView(
        initialDate: Date(),
        onConfirm: { _ in },
        onDismiss: {}
    )
}
