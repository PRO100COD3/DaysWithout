//
//  DateView.swift
//  DaysWithout
//

import SwiftUI
import UIKit

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
        ZStack{
            LinearGradient(colors: [Theme.backgroundColor[0], Theme.backgroundColor[1]], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                headerView
                Spacer()
                contentView
                    .padding(.horizontal, 23)
                Spacer()
            }
            .onAppear {
                viewModel.onConfirm = { [onConfirm] date in
                    onConfirm(date)
                }
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
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.mainHeadingColor)
            }
            .frame(width: 24, height: 24)
            Spacer()
            Text(viewModel.title)
                .font(.custom("Onest", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Theme.mainHeadingColor)
            Spacer()
            Color.clear
                .frame(width: 34, height: 36)
        }
        .padding(.horizontal, 16)
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
            VStack(spacing: 13) {
                HStack {
                    Button(action: viewModel.previousMonth) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 72/255, green: 153/255, blue: 79/255))
                            .padding(6)
                    }
                    Spacer()
                    Text(viewModel.monthYearTitle)
                        .font(.custom("Onest", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(Theme.mainHeadingColor)
                    Spacer()
                    Button(action: viewModel.nextMonth) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(red: 72/255, green: 153/255, blue: 79/255))
                            .padding(6)
                    }
                }
                
                HStack(spacing: 0) {
                    ForEach(Array(viewModel.weekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                        Text(symbol)
                            .font(.custom("Onest", size: 14))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255).opacity(0.3))
                            .frame(maxWidth: .infinity)
                    }
                }
                
                let days = viewModel.daysInMonth()
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
                LazyVGrid(columns: columns, spacing: 7) {
                    ForEach(Array(days.enumerated()), id: \.offset) { _, day in
                        if let date = day {
                            let selected = viewModel.isSelectedDay(date)
                            let isToday = viewModel.isToday(date)
                            let inMonth = viewModel.isCurrentMonth(date)
                            let dayColor = Color(red: 72/255, green: 153/255, blue: 79/255)
                            Button(action: { viewModel.selectDay(date) }) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.custom("Onest", size: 18))
                                    .fontWeight(.regular)
                                    .foregroundColor((selected || isToday) ? dayColor : (inMonth ? Theme.mainHeadingColor : Theme.mainDescriptionColor))
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(selected ? Color(red: 217/255, green: 248/255, blue: 201/255) : Color.clear)
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
            createButton
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
        .background(Color.white.opacity(0.85))
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(
                Color.black.opacity(0.08),
                lineWidth: 1
            ))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: Color.black.opacity(0.12), radius: 25, x: 0, y: 10)
    }
    
    private static let timeWheelRowHeight: CGFloat = 34
    private static let timeWheelVisibleHeight: CGFloat = 200
    
    private var timeCard: some View {
        VStack(spacing: 0) {
            TimePickerRepresentable(
                hourSelection: Binding(
                    get: { viewModel.selectedHour },
                    set: { viewModel.selectedHour = $0 }
                ),
                minuteSelection: Binding(
                    get: { viewModel.selectedMinute },
                    set: { viewModel.selectedMinute = $0 }
                )
            )
            .padding(.top, 24)
            .frame(height: Self.timeWheelVisibleHeight)
            createButton
                .padding(.top, 16)
                .padding(.horizontal, 20)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
        .overlay(timeWheelLinesOverlay)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(
                Color.black.opacity(0.08),
                lineWidth: 1
            ))
        .shadow(color: Color.black.opacity(0.12), radius: 25, x: 0, y: 10)
    }
    
    private var timeWheelLinesOverlay: some View {
        let rowHeight = Self.timeWheelRowHeight
        let totalHeight = Self.timeWheelVisibleHeight + 24
        let topInset = (totalHeight - rowHeight) / 2
        let lineColor = Color.black.opacity(0.12)
        return VStack(spacing: 0) {
            Spacer()
                .frame(height: topInset)
            Rectangle()
                .fill(lineColor)
                .frame(height: 1)
            Spacer()
                .frame(height: rowHeight)
            Rectangle()
                .fill(lineColor)
                .frame(height: 1)
            Spacer()
        }
        .allowsHitTesting(false)
    }
    
    private var createButton: some View {
        Button(action: viewModel.confirmCurrentStep) {
            Text("СОЗДАТЬ")
                .font(.custom("Onest", size: 14))
                .fontWeight(.medium)
                .foregroundColor(Color(red: 72/255, green: 153/255, blue: 79/255))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(red: 217/255, green: 248/255, blue: 201/255))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.top, 24)
        .padding(.bottom, 24)
        .pressAnimation()
    }
}

// MARK: - Пикер времени: один UIPickerView с двумя компонентами (часы и минуты)
private struct TimePickerRepresentable: UIViewRepresentable {
    @Binding var hourSelection: Int
    @Binding var minuteSelection: Int
    
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator
        picker.selectRow(hourSelection, inComponent: 0, animated: false)
        picker.selectRow(minuteSelection, inComponent: 1, animated: false)
        return picker
    }
    
    func updateUIView(_ picker: UIPickerView, context: Context) {
        context.coordinator.hourSelection = $hourSelection
        context.coordinator.minuteSelection = $minuteSelection
        
        if picker.selectedRow(inComponent: 0) != hourSelection {
            picker.selectRow(hourSelection, inComponent: 0, animated: false)
        }
        if picker.selectedRow(inComponent: 1) != minuteSelection {
            picker.selectRow(minuteSelection, inComponent: 1, animated: false)
        }
        
        // Убираем серый фон у выбранной строки
        if picker.subviews.count > 1 {
            picker.subviews[1].backgroundColor = .clear
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(hourSelection: $hourSelection, minuteSelection: $minuteSelection)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var hourSelection: Binding<Int>
        var minuteSelection: Binding<Int>
        
        init(hourSelection: Binding<Int>, minuteSelection: Binding<Int>) {
            self.hourSelection = hourSelection
            self.minuteSelection = minuteSelection
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            2
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? 24 : 60
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            "\(row)"
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 {
                hourSelection.wrappedValue = row
            } else {
                minuteSelection.wrappedValue = row
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            34
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            50
        }
    }
}

#Preview {
    DateView(
        initialDate: Date(),
        onConfirm: { _ in },
        onDismiss: {}
    )
}
