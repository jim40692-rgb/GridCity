import Foundation
import SwiftData

@Model
final class Tile {
    var x: Int
    var y: Int
    var typeRaw: String
    var developmentLevel: Int
    var isPowered: Bool
    var isWatered: Bool
    var pollution: Int

    var city: City?

    var type: TileType {
        get { TileType(rawValue: typeRaw) ?? .empty }
        set { typeRaw = newValue.rawValue }
    }

    init(x: Int, y: Int, type: TileType = .empty) {
        self.x = x
        self.y = y
        self.typeRaw = type.rawValue
        self.developmentLevel = 0
        self.isPowered = false
        self.isWatered = false
        self.pollution = 0
    }
}
