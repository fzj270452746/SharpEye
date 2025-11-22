import Foundation

enum SharpGameMode: String, Codable, CaseIterable {
    case cyclical
    case fusion

    var title: String {
        switch self {
        case .cyclical: return "Cycle Run"
        case .fusion: return "Fusion Run"
        }
    }

    var synopsis: String {
        switch self {
        case .cyclical:
            return "Tiles share one tribe while the tribes rotate every round."
        case .fusion:
            return "Every round blends all tribes for unpredictable peaks."
        }
    }
}

struct GameRecord: Codable, Identifiable {
    let id: UUID
    let createdAt: Date
    let mode: SharpGameMode
    let score: Int
    let depth: Int

    init(id: UUID = UUID(), createdAt: Date = Date(), mode: SharpGameMode, score: Int, depth: Int) {
        self.id = id
        self.createdAt = createdAt
        self.mode = mode
        self.score = score
        self.depth = depth
    }
}

struct GameLedger {
    static let shared = GameLedger()

    let defaults = UserDefaults.standard
    let key = "sharp.eye.ledger"

    func fetchRecords() -> [GameRecord] {
        guard let data = defaults.data(forKey: key) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([GameRecord].self, from: data)) ?? []
    }

    func appendRecord(_ record: GameRecord) {
        var current = fetchRecords()
        current.insert(record, at: 0)
        persist(current)
    }

    func purge(recordID: UUID) {
        var current = fetchRecords()
        current.removeAll { $0.id == recordID }
        persist(current)
    }

    func purgeAll() {
        defaults.removeObject(forKey: key)
    }

    func persist(_ records: [GameRecord]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(records) {
            defaults.set(data, forKey: key)
        }
    }
}

