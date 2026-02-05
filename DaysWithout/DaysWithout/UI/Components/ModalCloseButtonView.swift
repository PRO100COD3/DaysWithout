//
//  ModalCloseButtonView.swift
//  DaysWithout
//

import SwiftUI

/// Стиль кнопки закрытия модального окна (X).
enum ModalCloseButtonStyle {
    case support
    case selectPurchases
    case success

    var fontSize: CGFloat {
        switch self {
        case .support, .success: return Theme.supportCloseButtonFontSize
        case .selectPurchases: return Theme.selectPurchasesCloseButtonFontSize
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .support, .success: return .semibold
        case .selectPurchases: return .medium
        }
    }

    var size: CGFloat {
        switch self {
        case .support, .success: return Theme.supportCloseButtonSize
        case .selectPurchases: return Theme.selectPurchasesCloseButtonSize
        }
    }

    var padding: CGFloat {
        switch self {
        case .support, .success: return Theme.supportCloseButtonPadding
        case .selectPurchases: return Theme.selectPurchasesCloseButtonPadding
        }
    }
}

/// Кнопка закрытия (X) для модальных экранов.
struct ModalCloseButtonView: View {
    let style: ModalCloseButtonStyle
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .font(.system(size: style.fontSize, weight: style.fontWeight))
                .foregroundColor(Theme.mainHeadingColor)
                .frame(width: style.size, height: style.size)
        }
        .padding(style.padding)
    }
}
