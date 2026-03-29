import Foundation

struct PlacementValidator {
    static func canPlace(_ type: TileType, at x: Int, y: Int, in city: City, tiles: [GridPosition: Tile]) -> Bool {
        let pos = GridPosition(x: x, y: y)
        guard let tile = tiles[pos] else { return false }

        // Can't place on water
        if tile.type == .water { return false }

        // Can't place on occupied tile (must demolish first)
        if tile.type != .empty { return false }

        // Must afford it
        if city.treasury < type.cost { return false }

        return true
    }

    static func canDemolish(at x: Int, y: Int, tiles: [GridPosition: Tile]) -> Bool {
        let pos = GridPosition(x: x, y: y)
        guard let tile = tiles[pos] else { return false }
        return tile.type != .empty && tile.type != .water
    }
}
