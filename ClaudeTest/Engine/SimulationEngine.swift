import Foundation

struct TurnReport {
    var economyReport: EconomyReport
    var populationChange: Int
    var happiness: Double
    var previousHappiness: Double
    var events: [String]
}

struct SimulationEngine {
    static func advanceTurn(city: City, tiles: inout [GridPosition: Tile]) -> TurnReport {
        var events: [String] = []
        let previousHappiness = city.happiness

        // 1. Update infrastructure connectivity (power, water, pollution)
        InfrastructureEngine.updateConnectivity(city: city, tiles: &tiles)

        // 2. Develop zones
        let previousLevels = Dictionary(uniqueKeysWithValues: tiles.map { ($0.key, $0.value.developmentLevel) })
        ZoneEngine.developZones(city: city, tiles: &tiles)

        // Track new developments
        for (pos, tile) in tiles {
            if let prevLevel = previousLevels[pos], tile.developmentLevel > prevLevel {
                events.append("\(tile.type.displayName) developed at (\(pos.x), \(pos.y))!")
            }
        }

        // 3. Calculate economy
        let economyReport = EconomyEngine.calculate(city: city, tiles: tiles)
        city.treasury += economyReport.netIncome
        city.gdp = economyReport.totalRevenue

        if economyReport.netIncome > 0 {
            events.append("Revenue: +$\(economyReport.totalRevenue), Expenses: -$\(economyReport.maintenanceExpenses)")
        } else if economyReport.netIncome < 0 {
            events.append("Warning: Running a deficit of $\(economyReport.netIncome)!")
        }

        // 4. Calculate happiness
        city.happiness = HappinessEngine.calculate(city: city, tiles: tiles)

        // 5. Update population
        let popChange = PopulationEngine.calculate(city: city, tiles: tiles)
        city.population = max(0, city.population + popChange)

        // Recalculate based on actual housing
        let maxPop = PopulationEngine.recalculateTotalPopulation(tiles: tiles)
        city.population = min(city.population, maxPop)

        if popChange > 0 {
            events.append("\(popChange) new residents moved in!")
        } else if popChange < 0 {
            events.append("\(abs(popChange)) residents left the city.")
        }

        // 6. Check game over conditions
        if city.happiness < GameConstants.gameOverHappinessThreshold {
            city.unhappyStreak += 1
            events.append("Warning: Citizens are very unhappy! (\(city.unhappyStreak)/\(GameConstants.gameOverUnhappyStreakLimit) months)")
        } else {
            city.unhappyStreak = 0
        }

        if city.unhappyStreak >= GameConstants.gameOverUnhappyStreakLimit {
            city.isGameOver = true
            events.append("Game Over: Citizens revolted due to prolonged unhappiness!")
        }

        if city.treasury < GameConstants.gameOverDebtLimit {
            city.isGameOver = true
            events.append("Game Over: City went bankrupt!")
        }

        city.currentMonth += 1

        return TurnReport(
            economyReport: economyReport,
            populationChange: popChange,
            happiness: city.happiness,
            previousHappiness: previousHappiness,
            events: events
        )
    }
}
