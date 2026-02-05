//
//  CircularProgressView.swift
//  BadHabits
//
//  Created by Вадим Дзюба on 19.01.2026.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let days: Int
    let timeString: String
    
    private var daysWord: String {
        daysDeclension(days)
    }
    
    private func daysDeclension(_ number: Int) -> String {
        let mod10 = number % 10
        let mod100 = number % 100
        
        if mod100 >= 11 && mod100 <= 14 {
            return "дней"
        }
        
        switch mod10 {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(Theme.circularProgressRingBackgroundOpacity), lineWidth: Theme.circularProgressRingLineWidth)
                .frame(width: Theme.circularProgressRingSize, height: Theme.circularProgressRingSize)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(lineWidth: Theme.circularProgressRingLineWidth, lineCap: .round)
                )
                .frame(width: Theme.circularProgressRingSize, height: Theme.circularProgressRingSize)
                .rotationEffect(.degrees(Theme.circularProgressRingRotationDegrees))
            
            VStack(spacing: Theme.circularProgressContentStackSpacing) {
                Text("\(days)")
                    .font(.custom(Theme.headingFontName, size: Theme.circularProgressDaysFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.circularProgressTextColor)
                
                Text(daysWord)
                    .font(.custom(Theme.headingFontName, size: Theme.circularProgressDaysWordFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.circularProgressTextColor.opacity(Theme.circularProgressDaysWordOpacity))
                    .padding(.top, Theme.circularProgressDaysWordTopPadding)
                
                Text(timeString)
                    .font(.custom(Theme.headingFontName, size: Theme.circularProgressTimeFontSize))
                    .fontWeight(.medium)
                    .foregroundColor(Theme.circularProgressTextColor)
                    .padding(.top, Theme.circularProgressTimeTopPadding)
            }
        }
    }
}
