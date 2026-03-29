import SwiftUI

struct MapView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            let columns = Array(
                repeating: GridItem(.fixed(GameConstants.tileSize), spacing: 0),
                count: viewModel.city.gridWidth
            )
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(0..<viewModel.city.gridWidth * viewModel.city.gridHeight, id: \.self) { index in
                    let x = index % viewModel.city.gridWidth
                    let y = index / viewModel.city.gridWidth
                    let pos = GridPosition(x: x, y: y)

                    if let tile = viewModel.tileMap[pos] {
                        TileView(
                            tile: tile,
                            isSelected: viewModel.selectedPosition == pos,
                            selectedTool: viewModel.selectedTool
                        )
                        .onTapGesture {
                            viewModel.handleTap(at: x, y: y)
                        }
                    }
                }
            }
            .scaleEffect(scale)
            .frame(
                width: CGFloat(viewModel.city.gridWidth) * GameConstants.tileSize * scale,
                height: CGFloat(viewModel.city.gridHeight) * GameConstants.tileSize * scale
            )
        }
        .gesture(
            MagnifyGesture()
                .onChanged { value in
                    scale = lastScale * value.magnification
                    scale = min(max(scale, 0.5), 3.0)
                }
                .onEnded { _ in
                    lastScale = scale
                }
        )
        .background(Color(white: 0.9))
    }
}
