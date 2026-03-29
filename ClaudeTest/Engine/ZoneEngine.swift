import Foundation

struct ZoneEngine {
    static func developZones(city: City, tiles: inout [GridPosition: Tile]) {
        let zones = tiles.values.filter {
            $0.type == .residential || $0.type == .commercial || $0.type == .industrial
        }

        for tile in zones {
            guard tile.developmentLevel < GameConstants.maxDevelopmentLevel else { continue }
            guard tile.isPowered && tile.isWatered else { continue }
            guard hasAdjacentRoad(tile: tile, tiles: tiles) else { continue }

            // Commercial needs nearby residential population
            if tile.type == .commercial {
                let nearbyPop = nearbyPopulation(tile: tile, tiles: tiles, radius: 5)
                if nearbyPop < 20 { continue }
            }

            var chance = GameConstants.baseDevelopmentChance
            chance *= city.happiness
            chance *= (1.0 - averageTaxRate(for: tile.type, city: city))

            if Double.random(in: 0...1) < chance {
                tile.developmentLevel += 1
            }
        }
    }

    private static func hasAdjacentRoad(tile: Tile, tiles: [GridPosition: Tile]) -> Bool {
        let pos = GridPosition(x: tile.x, y: tile.y)
        return pos.neighbors.contains { neighbor in
            tiles[neighbor]?.type == .road
        }
    }

    private static func nearbyPopulation(tile: Tile, tiles: [GridPosition: Tile], radius: Int) -> Int {
        var pop = 0
        for dy in -radius...radius {
            for dx in -radius...radius {
                let pos = GridPosition(x: tile.x + dx, y: tile.y + dy)
                if let nearby = tiles[pos], nearby.type == .residential {
                    pop += GameConstants.residentialPopPerLevel[min(nearby.developmentLevel, 3)]
                }
            }
        }
        return pop
    }

    private static func averageTaxRate(for type: TileType, city: City) -> Double {
        switch type {
        case .residential: return city.residentialTaxRate
        case .commercial: return city.commercialTaxRate
        case .industrial: return city.industrialTaxRate
        default: return 0
        }
    }
}
