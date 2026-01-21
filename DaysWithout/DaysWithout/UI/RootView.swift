//
//  RootView.swift
//  DaysWithout
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import SwiftUI

/// Корневой View приложения.
/// Содержит только привязку к ViewModel, без верстки и бизнес-логики.
struct RootView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = RootViewModel()
    
    // MARK: - Body
    
    var body: some View {
        // Placeholder — будет заменён на реальный UI
        EmptyView()
    }
}

// MARK: - Preview

#Preview {
    RootView()
}
