//
//  RestartRecord.swift
//  DaysWithout
//

import Foundation

/// Запись о рестарте таймера: период (дни), причина и диапазон дат
struct RestartRecord: Codable, Identifiable {
    let id: UUID
    /// Количество дней в завершённом периоде
    let days: Int
    /// Причина рестарта
    let reason: String
    /// Начало периода
    let periodStart: Date
    /// Конец периода (момент рестарта)
    let periodEnd: Date
    
    init(id: UUID = UUID(), days: Int, reason: String, periodStart: Date, periodEnd: Date) {
        self.id = id
        self.days = days
        self.reason = reason
        self.periodStart = periodStart
        self.periodEnd = periodEnd
    }
}
