import Foundation

struct PopulationEngine {
    static func calculate(city: City, tiles: [GridPosition: Tile]) -> Int {
        // Calculate total housing capacity
        let housingCapacity = tiles.values
            .filter { $0.type == .residential && $0.developmentLevel > 0 }
            .reduce(0) { total, tile in
                total + GameConstants.residentialPopPerLevel[min(tile.developmentLevel, 3)]
            }

        guard housingCapacity > 0 else { return 0 }

        let currentPop = city.population

        if city.happiness >= 0.4 {
            // Growth: population moves toward capacity based on happiness
            let availableHousing = housingCapacity - currentPop
            if availableHousing > 0 {
                let growthRate = GameConstants.basePopulationGrowthRate * city.happiness
                let growth = max(1, Int(Double(availableHousing) * growthRate))
                return growth
            }
            return 0
        } else {
            // Decline: people leave when unhappy
            let decline = max(1, Int(Double(currentPop) * GameConstants.unhappinessPopulationDeclineRate))
            return -decline
        }
    }

    static func recalculateTotalPopulation(tiles: [GridPosition: Tile]) -> Int {
        return tiles.values
            .filter { $0.type == .residential && $0.developmentLevel > 0 }
            .reduce(0) { total, tile in
                total + GameConstants.residentialPopPerLevel[min(tile.developmentLevel, 3)]
            }
    }
}
