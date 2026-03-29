import Foundation

struct GridPosition: Hashable {
    let x: Int
    let y: Int

    var neighbors: [GridPosition] {
        [
            GridPosition(x: x - 1, y: y),
            GridPosition(x: x + 1, y: y),
            GridPosition(x: x, y: y - 1),
            GridPosition(x: x, y: y + 1)
        ]
    }
}

struct InfrastructureEngine {
    static func updateConnectivity(city: City, tiles: inout [GridPosition: Tile]) {
        // Reset all connectivity
        for tile in tiles.values {
            tile.isPowered = false
            tile.isWatered = false
            tile.pollution = 0
        }

        // BFS from power sources
        let powerSources = tiles.values.filter { $0.type.powerOutput > 0 }
        for source in powerSources {
            spreadPower(from: source, tiles: &tiles, city: city)
        }

        // BFS from water sources
        let waterSources = tiles.values.filter { $0.type.waterOutput > 0 }
        for source in waterSources {
            spreadWater(from: source, tiles: &tiles, city: city)
        }

        // Spread pollution
        let polluters = tiles.values.filter { $0.type.pollutionOutput > 0 }
        for source in polluters {
            spreadPollution(from: source, tiles: &tiles)
        }
    }

    private static func spreadPower(from source: Tile, tiles: inout [GridPosition: Tile], city: City) {
        var visited = Set<GridPosition>()
        var queue: [GridPosition] = [GridPosition(x: source.x, y: source.y)]
        visited.insert(queue[0])

        while !queue.isEmpty {
            let pos = queue.removeFirst()
            guard let tile = tiles[pos] else { continue }

            tile.isPowered = true

            for neighbor in pos.neighbors {
                guard !visited.contains(neighbor) else { continue }
                guard neighbor.x >= 0 && neighbor.x < city.gridWidth &&
                      neighbor.y >= 0 && neighbor.y < city.gridHeight else { continue }
                guard let neighborTile = tiles[neighbor] else { continue }

                // Power spreads through power lines, roads, and reaches adjacent zones/buildings
                let conductsPower = neighborTile.type == .powerLine ||
                                    neighborTile.type == .road ||
                                    neighborTile.type != .empty && neighborTile.type != .water
                if conductsPower {
                    visited.insert(neighbor)
                    queue.append(neighbor)
                }
            }
        }
    }

    private static func spreadWater(from source: Tile, tiles: inout [GridPosition: Tile], city: City) {
        var visited = Set<GridPosition>()
        var queue: [GridPosition] = [GridPosition(x: source.x, y: source.y)]
        visited.insert(queue[0])

        while !queue.isEmpty {
            let pos = queue.removeFirst()
            guard let tile = tiles[pos] else { continue }

            tile.isWatered = true

            for neighbor in pos.neighbors {
                guard !visited.contains(neighbor) else { continue }
                guard neighbor.x >= 0 && neighbor.x < city.gridWidth &&
                      neighbor.y >= 0 && neighbor.y < city.gridHeight else { continue }
                guard let neighborTile = tiles[neighbor] else { continue }

                let conductsWater = neighborTile.type == .waterPipe ||
                                    neighborTile.type == .road ||
                                    neighborTile.type != .empty && neighborTile.type != .water
                if conductsWater {
                    visited.insert(neighbor)
                    queue.append(neighbor)
                }
            }
        }
    }

    private static func spreadPollution(from source: Tile, tiles: inout [GridPosition: Tile]) {
        let radius = source.type.effectRadius
        let basePollution = source.type.pollutionOutput
        let sourcePos = GridPosition(x: source.x, y: source.y)

        for dy in -radius...radius {
            for dx in -radius...radius {
                let pos = GridPosition(x: source.x + dx, y: source.y + dy)
                guard let tile = tiles[pos] else { continue }

                let distance = abs(dx) + abs(dy)
                if distance <= radius && pos != sourcePos {
                    let pollutionAtDistance = max(0, basePollution - distance)
                    tile.pollution = min(10, tile.pollution + pollutionAtDistance)
                }
            }
        }
    }
}
