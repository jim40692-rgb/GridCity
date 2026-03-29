import Foundation
import SwiftData

@Model
final class City {
    var name: String
    var currentMonth: Int
    var population: Int
    var happiness: Double
    var treasury: Int
    var gdp: Int

    var residentialTaxRate: Double
    var commercialTaxRate: Double
    var industrialTaxRate: Double

    var gridWidth: Int
    var gridHeight: Int

    var unhappyStreak: Int
    var isGameOver: Bool
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Tile.city)
    var tiles: [Tile]

    init(name: String,
         gridWidth: Int = GameConstants.gridWidth,
         gridHeight: Int = GameConstants.gridHeight) {
        self.name = name
        self.currentMonth = 1
        self.population = GameConstants.startingPopulation
        self.happiness = GameConstants.startingHappiness
        self.treasury = GameConstants.startingTreasury
        self.gdp = 0
        self.residentialTaxRate = GameConstants.defaultResidentialTax
        self.commercialTaxRate = GameConstants.defaultCommercialTax
        self.industrialTaxRate = GameConstants.defaultIndustrialTax
        self.gridWidth = gridWidth
        self.gridHeight = gridHeight
        self.unhappyStreak = 0
        self.isGameOver = false
        self.createdAt = Date()
        self.tiles = []
    }

    func createTiles() {
        for y in 0..<gridHeight {
            for x in 0..<gridWidth {
                let tile = Tile(x: x, y: y)
                tiles.append(tile)
            }
        }
    }

    var dateString: String {
        let year = 2026 + (currentMonth - 1) / 12
        let month = ((currentMonth - 1) % 12) + 1
        let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        return "\(monthNames[month - 1]) \(year)"
    }
}
