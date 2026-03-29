import Foundation
import SwiftUI
import SwiftData
import Combine

class GameViewModel: ObservableObject {
    @Published var city: City
    @Published var tileMap: [GridPosition: Tile] = [:]
    @Published var selectedTool: TileType?
    @Published var selectedPosition: GridPosition?
    @Published var isDemolishMode: Bool = false
    @Published var lastReport: TurnReport?
    @Published var showTurnSummary: Bool = false
    @Published var statusMessage: String?

    private var modelContext: ModelContext

    init(city: City, modelContext: ModelContext) {
        self.city = city
        self.modelContext = modelContext
        rebuildTileMap()
    }

    func rebuildTileMap() {
        var map: [GridPosition: Tile] = [:]
        for tile in city.tiles {
            map[GridPosition(x: tile.x, y: tile.y)] = tile
        }
        tileMap = map
    }

    func selectTool(_ type: TileType) {
        isDemolishMode = false
        if selectedTool == type {
            selectedTool = nil
        } else {
            selectedTool = type
        }
        selectedPosition = nil
    }

    func toggleDemolishMode() {
        selectedTool = nil
        isDemolishMode.toggle()
        selectedPosition = nil
    }

    func handleTap(at x: Int, y: Int) {
        let pos = GridPosition(x: x, y: y)

        if isDemolishMode {
            demolish(at: x, y: y)
            return
        }

        guard let tool = selectedTool else {
            // Just inspect
            selectedPosition = (selectedPosition == pos) ? nil : pos
            return
        }

        placeTile(tool, at: x, y: y)
    }

    func placeTile(_ type: TileType, at x: Int, y: Int) {
        guard PlacementValidator.canPlace(type, at: x, y: y, in: city, tiles: tileMap) else {
            statusMessage = "Can't place here!"
            return
        }

        guard let tile = tileMap[GridPosition(x: x, y: y)] else { return }

        city.treasury -= type.cost
        tile.type = type

        if type.category == .zone {
            tile.developmentLevel = 0
        }

        statusMessage = "Placed \(type.displayName) (-$\(type.cost))"
        objectWillChange.send()
        save()
    }

    func demolish(at x: Int, y: Int) {
        guard PlacementValidator.canDemolish(at: x, y: y, tiles: tileMap) else {
            statusMessage = "Nothing to demolish!"
            return
        }

        guard let tile = tileMap[GridPosition(x: x, y: y)] else { return }

        let refund = Int(Double(tile.type.cost) * GameConstants.demolishRefundRate)
        city.treasury += refund
        let oldName = tile.type.displayName
        tile.type = .empty
        tile.developmentLevel = 0
        tile.isPowered = false
        tile.isWatered = false
        tile.pollution = 0

        statusMessage = "Demolished \(oldName) (+$\(refund))"
        objectWillChange.send()
        save()
    }

    func advanceTurn() {
        var tiles = tileMap
        let report = SimulationEngine.advanceTurn(city: city, tiles: &tiles)
        tileMap = tiles
        lastReport = report
        showTurnSummary = true
        objectWillChange.send()
        save()
    }

    var currentEconomyReport: EconomyReport {
        EconomyEngine.calculate(city: city, tiles: tileMap)
    }

    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }
}
