import SwiftUI

struct BuildToolbar: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var selectedCategory: TileCategory = .zone

    var body: some View {
        VStack(spacing: 0) {
            // Category tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(TileCategory.allCases) { category in
                        Button(action: { selectedCategory = category }) {
                            Text(category.rawValue)
                                .font(.caption)
                                .fontWeight(selectedCategory == category ? .bold : .regular)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedCategory == category ? .white : .primary)
                                .cornerRadius(8)
                        }
                    }

                    Divider().frame(height: 20)

                    // Demolish button
                    Button(action: { viewModel.toggleDemolishMode() }) {
                        Text("🔨 Demolish")
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(viewModel.isDemolishMode ? Color.red : Color.gray.opacity(0.2))
                            .foregroundColor(viewModel.isDemolishMode ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 4)

            // Tool items for selected category
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(toolsForCategory) { type in
                        Button(action: { viewModel.selectTool(type) }) {
                            VStack(spacing: 2) {
                                Text(type.emoji)
                                    .font(.title2)
                                Text(type.displayName)
                                    .font(.system(size: 9))
                                    .lineLimit(1)
                                Text("$\(type.cost)")
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                            }
                            .frame(width: 64, height: 64)
                            .background(viewModel.selectedTool == type ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(viewModel.selectedTool == type ? Color.blue : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 4)
        }
        .background(Color(UIColor.systemBackground).shadow(radius: 2))
    }

    private var toolsForCategory: [TileType] {
        TileType.buildable.filter { $0.category == selectedCategory }
    }
}
