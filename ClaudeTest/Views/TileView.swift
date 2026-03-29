import SwiftUI

struct TileView: View {
    let tile: Tile
    let isSelected: Bool
    let selectedTool: TileType?

    var body: some View {
        ZStack {
            Rectangle()
                .fill(backgroundColor)

            if tile.type != .empty {
                Text(tile.type.emojiForLevel(tile.developmentLevel))
                    .font(.system(size: 18))
                    .minimumScaleFactor(0.5)
            }
        }
        .frame(width: GameConstants.tileSize, height: GameConstants.tileSize)
        .border(Color.gray.opacity(0.15), width: 0.5)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(isSelected ? Color.yellow : Color.clear, lineWidth: 2)
        )
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.yellow.opacity(0.3)
        }
        switch tile.type {
        case .empty:
            return Color.green.opacity(0.15)
        case .water:
            return Color.blue.opacity(0.3)
        case .road:
            return Color.gray.opacity(0.6)
        case .residential:
            return Color.green.opacity(0.25)
        case .commercial:
            return Color.blue.opacity(0.15)
        case .industrial:
            return Color.orange.opacity(0.15)
        default:
            return Color.white.opacity(0.3)
        }
    }
}
