import UIKit

struct SharpEyeModel: Hashable {
    enum TileTribe: String, CaseIterable {
        case aurora = "S_one"
        case ember = "S_two"
        case cinder = "S_thre"

        var englishTitle: String {
            switch self {
            case .aurora: return "Verdant Bamboos"
            case .ember: return "Golden Coins"
            case .cinder: return "Crimson Characters"
            }
        }

        var accentColor: UIColor {
            switch self {
            case .aurora: return UIColor(red: 52/255, green: 201/255, blue: 166/255, alpha: 1)
            case .ember: return UIColor(red: 240/255, green: 172/255, blue: 88/255, alpha: 1)
            case .cinder: return UIColor(red: 226/255, green: 99/255, blue: 114/255, alpha: 1)
            }
        }
    }

    let tribe: TileTribe
    let faceValue: Int

    var assetName: String {
        "\(tribe.rawValue)\(faceValue)"
    }

    var tileImage: UIImage? {
        UIImage(named: assetName)
    }
}

struct SharpEyeRepository {
    static let shared = SharpEyeRepository()

    let deck: [SharpEyeModel.TileTribe: [SharpEyeModel]]
    let entireStream: [SharpEyeModel]

    init() {
        var compiledDeck: [SharpEyeModel.TileTribe: [SharpEyeModel]] = [:]
        SharpEyeModel.TileTribe.allCases.forEach { tribe in
            let slice = (1...9).map { SharpEyeModel(tribe: tribe, faceValue: $0) }
            compiledDeck[tribe] = slice
        }

        deck = compiledDeck
        entireStream = SharpEyeModel.TileTribe.allCases.flatMap { compiledDeck[$0] ?? [] }
    }

    func tiles(for tribe: SharpEyeModel.TileTribe) -> [SharpEyeModel] {
        deck[tribe] ?? []
    }

    func fusionTiles(count: Int) -> [SharpEyeModel] {
        guard !entireStream.isEmpty else { return [] }
        var bag = entireStream.shuffled()
        var chosen: [SharpEyeModel] = []
        for _ in 0..<max(count, 1) {
            if bag.isEmpty { bag = entireStream.shuffled() }
            chosen.append(bag.removeFirst())
        }
        return chosen
    }
}