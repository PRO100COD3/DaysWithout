//
//  TimePickerView.swift
//  DaysWithout
//

import SwiftUI
import UIKit

/// Пикер времени: один UIPickerView с двумя компонентами (часы и минуты).
struct TimePickerView: View {
    @Binding var hourSelection: Int
    @Binding var minuteSelection: Int

    var body: some View {
        TimePickerRepresentable(
            hourSelection: $hourSelection,
            minuteSelection: $minuteSelection
        )
    }
}

// MARK: - UIKit Representable

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
            Theme.dateTimePickerComponentCount
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            component == 0 ? Theme.dateTimePickerHoursCount : Theme.dateTimePickerMinutesCount
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
            Theme.dateTimePickerRowHeight
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            Theme.dateTimePickerComponentWidth
        }
    }
}
