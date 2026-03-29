import Foundation

enum TileCategory: String, CaseIterable, Identifiable {
    case zone = "Zones"
    case infrastructure = "Roads"
    case power = "Power"
    case water = "Water"
    case services = "Services"

    var id: String { rawValue }
}

enum TileType: String, Codable, CaseIterable, Identifiable {
    // Terrain
    case empty
    case water

    // Zones
    case residential
    case commercial
    case industrial

    // Infrastructure
    case road
    case powerLine
    case waterPipe

    // Power
    case coalPlant
    case solarFarm
    case windTurbine
    case nuclearPlant

    // Water
    case waterTower
    case sewagePlant

    // Services
    case park
    case school
    case hospital
    case policeStation
    case fireStation
    case busStop

    var id: String { rawValue }

    var cost: Int {
        switch self {
        case .empty, .water: return 0
        case .residential: return 100
        case .commercial: return 150
        case .industrial: return 200
        case .road: return 20
        case .powerLine: return 30
        case .waterPipe: return 25
        case .coalPlant: return 500
        case .solarFarm: return 800
        case .windTurbine: return 700
        case .nuclearPlant: return 2000
        case .waterTower: return 300
        case .sewagePlant: return 400
        case .park: return 200
        case .school: return 500
        case .hospital: return 800
        case .policeStation: return 400
        case .fireStation: return 400
        case .busStop: return 150
        }
    }

    var monthlyCost: Int {
        switch self {
        case .empty, .water, .residential, .commercial, .industrial: return 0
        case .road: return 2
        case .powerLine: return 1
        case .waterPipe: return 1
        case .coalPlant: return 80
        case .solarFarm: return 20
        case .windTurbine: return 15
        case .nuclearPlant: return 120
        case .waterTower: return 15
        case .sewagePlant: return 25
        case .park: return 10
        case .school: return 40
        case .hospital: return 60
        case .policeStation: return 30
        case .fireStation: return 30
        case .busStop: return 10
        }
    }

    var emoji: String {
        switch self {
        case .empty: return ""
        case .water: return "🌊"
        case .residential: return "🏠"
        case .commercial: return "🏪"
        case .industrial: return "🏭"
        case .road: return "⬛"
        case .powerLine: return "🔌"
        case .waterPipe: return "🔵"
        case .coalPlant: return "🏗️"
        case .solarFarm: return "☀️"
        case .windTurbine: return "🌀"
        case .nuclearPlant: return "⚛️"
        case .waterTower: return "💧"
        case .sewagePlant: return "🚰"
        case .park: return "🌳"
        case .school: return "🏫"
        case .hospital: return "🏥"
        case .policeStation: return "🚔"
        case .fireStation: return "🚒"
        case .busStop: return "🚌"
        }
    }

    var displayName: String {
        switch self {
        case .empty: return "Empty"
        case .water: return "Water"
        case .residential: return "Residential"
        case .commercial: return "Commercial"
        case .industrial: return "Industrial"
        case .road: return "Road"
        case .powerLine: return "Power Line"
        case .waterPipe: return "Water Pipe"
        case .coalPlant: return "Coal Plant"
        case .solarFarm: return "Solar Farm"
        case .windTurbine: return "Wind Turbine"
        case .nuclearPlant: return "Nuclear Plant"
        case .waterTower: return "Water Tower"
        case .sewagePlant: return "Sewage Plant"
        case .park: return "Park"
        case .school: return "School"
        case .hospital: return "Hospital"
        case .policeStation: return "Police Station"
        case .fireStation: return "Fire Station"
        case .busStop: return "Bus Stop"
        }
    }

    var powerOutput: Int {
        switch self {
        case .coalPlant: return 50
        case .solarFarm: return 25
        case .windTurbine: return 20
        case .nuclearPlant: return 100
        default: return 0
        }
    }

    var waterOutput: Int {
        switch self {
        case .waterTower: return 40
        case .sewagePlant: return 30
        default: return 0
        }
    }

    var pollutionOutput: Int {
        switch self {
        case .coalPlant: return 8
        case .industrial: return 4
        case .sewagePlant: return 2
        default: return 0
        }
    }

    var effectRadius: Int {
        switch self {
        case .coalPlant, .nuclearPlant: return 6
        case .solarFarm, .windTurbine: return 4
        case .waterTower, .sewagePlant: return 5
        case .park: return 3
        case .school, .hospital: return 5
        case .policeStation, .fireStation: return 4
        case .busStop: return 3
        default: return 0
        }
    }

    var category: TileCategory? {
        switch self {
        case .residential, .commercial, .industrial: return .zone
        case .road, .powerLine, .waterPipe: return .infrastructure
        case .coalPlant, .solarFarm, .windTurbine, .nuclearPlant: return .power
        case .waterTower, .sewagePlant: return .water
        case .park, .school, .hospital, .policeStation, .fireStation, .busStop: return .services
        case .empty, .water: return nil
        }
    }

    static var buildable: [TileType] {
        allCases.filter { $0 != .empty && $0 != .water }
    }

    func emojiForLevel(_ level: Int) -> String {
        switch self {
        case .residential:
            switch level {
            case 0: return "🏗️"
            case 1: return "🏠"
            case 2: return "🏘️"
            default: return "🏢"
            }
        case .commercial:
            switch level {
            case 0: return "🏗️"
            case 1: return "🏪"
            case 2: return "🏬"
            default: return "🏦"
            }
        case .industrial:
            switch level {
            case 0: return "🏗️"
            case 1: return "🏭"
            default: return "🏭"
            }
        default:
            return emoji
        }
    }
}
