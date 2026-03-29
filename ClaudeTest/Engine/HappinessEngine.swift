import Foundation

struct HappinessEngine {
    static func calculate(city: City, tiles: [GridPosition: Tile]) -> Double {
        let residentialTiles = tiles.values.filter { $0.type == .residential && $0.developmentLevel > 0 }
        guard !residentialTiles.isEmpty else { return GameConstants.startingHappiness }

        let taxScore = calculateTaxScore(city: city)
        let serviceScore = calculateServiceScore(residentialTiles: residentialTiles, tiles: tiles)
        let pollutionScore = calculatePollutionScore(residentialTiles: residentialTiles)
        let parkScore = calculateParkScore(residentialTiles: residentialTiles, tiles: tiles)
        let transitScore = calculateTransitScore(residentialTiles: residentialTiles, tiles: tiles)
        let commuteScore = calculateCommuteScore(residentialTiles: residentialTiles, tiles: tiles)
        let utilityScore = calculateUtilityScore(residentialTiles: residentialTiles)

        let happiness = taxScore * GameConstants.happinessWeightTax +
                        serviceScore * GameConstants.happinessWeightServices +
                        pollutionScore * GameConstants.happinessWeightPollution +
                        parkScore * GameConstants.happinessWeightParks +
                        transitScore * GameConstants.happinessWeightTransit +
                        commuteScore * GameConstants.happinessWeightCommute +
                        utilityScore * GameConstants.happinessWeightUtilities

        return min(1.0, max(0.0, happiness))
    }

    private static func calculateTaxScore(city: City) -> Double {
        let avgTax = (city.residentialTaxRate + city.commercialTaxRate + city.industrialTaxRate) / 3.0
        return max(0, 1.0 - (avgTax / GameConstants.maxTaxRate) * 1.5)
    }

    private static func calculateServiceScore(residentialTiles: [Tile], tiles: [GridPosition: Tile]) -> Double {
        let serviceTypes: [TileType] = [.school, .hospital, .policeStation, .fireStation]
        var totalCoverage = 0.0

        for res in residentialTiles {
            var covered = 0
            for serviceType in serviceTypes {
                if hasNearbyBuilding(type: serviceType, near: res, tiles: tiles) {
                    covered += 1
                }
            }
            totalCoverage += Double(covered) / Double(serviceTypes.count)
        }

        return totalCoverage / Double(residentialTiles.count)
    }

    private static func calculatePollutionScore(residentialTiles: [Tile]) -> Double {
        let totalPollution = residentialTiles.reduce(0) { $0 + $1.pollution }
        let avgPollution = Double(totalPollution) / Double(residentialTiles.count)
        return max(0, 1.0 - avgPollution / 5.0)
    }

    private static func calculateParkScore(residentialTiles: [Tile], tiles: [GridPosition: Tile]) -> Double {
        var covered = 0
        for res in residentialTiles {
            if hasNearbyBuilding(type: .park, near: res, tiles: tiles) {
                covered += 1
            }
        }
        return Double(covered) / Double(residentialTiles.count)
    }

    private static func calculateTransitScore(residentialTiles: [Tile], tiles: [GridPosition: Tile]) -> Double {
        var covered = 0
        for res in residentialTiles {
            if hasNearbyBuilding(type: .busStop, near: res, tiles: tiles) {
                covered += 1
            }
        }
        return Double(covered) / Double(residentialTiles.count)
    }

    private static func calculateCommuteScore(residentialTiles: [Tile], tiles: [GridPosition: Tile]) -> Double {
        let jobTiles = tiles.values.filter {
            ($0.type == .commercial || $0.type == .industrial) && $0.developmentLevel > 0
        }
        guard !jobTiles.isEmpty else { return 0.5 }

        var connectedCount = 0
        for res in residentialTiles {
            let pos = GridPosition(x: res.x, y: res.y)
            if pos.neighbors.contains(where: { tiles[$0]?.type == .road }) {
                connectedCount += 1
            }
        }
        return Double(connectedCount) / Double(residentialTiles.count)
    }

    private static func calculateUtilityScore(residentialTiles: [Tile]) -> Double {
        var powered = 0
        var watered = 0
        for res in residentialTiles {
            if res.isPowered { powered += 1 }
            if res.isWatered { watered += 1 }
        }
        let powerScore = Double(powered) / Double(residentialTiles.count)
        let waterScore = Double(watered) / Double(residentialTiles.count)
        return (powerScore + waterScore) / 2.0
    }

    private static func hasNearbyBuilding(type: TileType, near tile: Tile, tiles: [GridPosition: Tile]) -> Bool {
        let radius = type.effectRadius
        for dy in -radius...radius {
            for dx in -radius...radius {
                let pos = GridPosition(x: tile.x + dx, y: tile.y + dy)
                if tiles[pos]?.type == type { return true }
            }
        }
        return false
    }
}
