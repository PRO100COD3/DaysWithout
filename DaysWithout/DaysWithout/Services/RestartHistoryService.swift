//
//  RestartHistoryService.swift
//  DaysWithout
//

import Foundation

/// Протокол сервиса истории рестартов по карточке
protocol RestartHistoryServiceProtocol: Sendable {
    /// История рестартов для карточки (новые сверху)
    func getHistory(cardId: UUID) -> [RestartRecord]
    /// Добавить запись о рестарте
    func addRecord(cardId: UUID, record: RestartRecord)
}

/// Хранение истории рестартов в UserDefaults (по cardId)
final class RestartHistoryService: RestartHistoryServiceProtocol {
    private let defaults = UserDefaults.standard
    private let keyPrefix = "RestartHistory_"
    
    private func key(for cardId: UUID) -> String {
        "\(keyPrefix)\(cardId.uuidString)"
    }
    
    func getHistory(cardId: UUID) -> [RestartRecord] {
        guard let data = defaults.data(forKey: key(for: cardId)) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([RestartRecord].self, from: data)) ?? []
    }
    
    func addRecord(cardId: UUID, record: RestartRecord) {
        var list = getHistory(cardId: cardId)
        list.insert(record, at: 0)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(list) else { return }
        defaults.set(data, forKey: key(for: cardId))
    }
}
