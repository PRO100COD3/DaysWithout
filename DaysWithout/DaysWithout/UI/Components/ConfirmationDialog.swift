//
//  ConfirmationDialog.swift
//  BadHabits
//
//  Created by Вадим Дзюба on 21.01.2026.
//

import SwiftUI

struct ConfirmationDialog: View {
    @Binding var isPresented: Bool
    
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        if isPresented {
            VStack(spacing: 12) {
                HStack {
                    Text("Подтвердите удаление")
                        .font(.custom("Onest", size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 34/255, green: 34/255, blue: 34/255))
                    
                    Spacer()
                }
                
                HStack {
                    Text("Вы уверены, что хотите \nудалить эту карточку?")
                        .font(.custom("Onest", size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(Color(red: 85/255, green: 85/255, blue: 85/255))
                        .lineLimit(2)
                    
                    Spacer()
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            onCancel()
                        }
                    }) {
                        Text("ОТМЕНА")
                            .font(.custom("Onest", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 110/255, green: 110/255, blue: 110/255))
                            .frame(maxWidth: .infinity, maxHeight: 36)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(red: 204/255, green: 204/255, blue: 204/255).opacity(0.8), lineWidth: 1)
                                    }
                            }
                    }
                    .pressAnimation()
                    .padding(.top, 12)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.18)) {
                            onConfirm()
                        }
                    }) {
                        Text("УДАЛИТЬ")
                            .font(.custom("Onest", size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color(red: 244/255, green: 244/255, blue: 244/255))
                            .frame(maxWidth: .infinity, maxHeight: 36)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Theme.redButton)
                                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(red: 208/255, green: 208/255, blue: 208/255).opacity(0.9), lineWidth: 1)
                                    }
                            }
                    }
                    .pressAnimation()
                    .padding(.top, 12)
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.984, green: 0.984, blue: 0.984),
                                Color(red: 0.922, green: 0.922, blue: 0.922)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 4)
            }
            .padding(.horizontal, 37)
            .opacity(isPresented ? 1.0 : 0.0)
            .scaleEffect(isPresented ? 1.0 : 0.95)
        }
    }
}
