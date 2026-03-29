import Foundation

struct EconomyReport {
    var residentialRevenue: Int
    var commercialRevenue: Int
    var industrialRevenue: Int
    var totalRevenue: Int
    var maintenanceExpenses: Int
    var netIncome: Int
}

struct EconomyEngine {
    static func calculate(city: City, tiles: [GridPosition: Tile]) -> EconomyReport {
        var residentialRevenue = 0
        var commercialRevenue = 0
        var industrialRevenue = 0
        var maintenanceExpenses = 0

        for tile in tiles.values {
            // Maintenance costs
            maintenanceExpenses += tile.type.monthlyCost

            // Revenue from developed zones
            guard tile.developmentLevel > 0 else { continue }

            switch tile.type {
            case .residential:
                let pop = GameConstants.residentialPopPerLevel[min(tile.developmentLevel, 3)]
                residentialRevenue += Int(Double(pop) * city.residentialTaxRate * Double(GameConstants.residentialRevenuePerPop))
            case .commercial:
                let jobs = GameConstants.commercialJobsPerLevel[min(tile.developmentLevel, 3)]
                commercialRevenue += Int(Double(jobs) * city.commercialTaxRate * Double(GameConstants.commercialRevenuePerJob))
            case .industrial:
                let jobs = GameConstants.industrialJobsPerLevel[min(tile.developmentLevel, 3)]
                industrialRevenue += Int(Double(jobs) * city.industrialTaxRate * Double(GameConstants.industrialRevenuePerJob))
            default:
                break
            }
        }

        let totalRevenue = residentialRevenue + commercialRevenue + industrialRevenue
        let netIncome = totalRevenue - maintenanceExpenses

        return EconomyReport(
            residentialRevenue: residentialRevenue,
            commercialRevenue: commercialRevenue,
            industrialRevenue: industrialRevenue,
            totalRevenue: totalRevenue,
            maintenanceExpenses: maintenanceExpenses,
            netIncome: netIncome
        )
    }
}
