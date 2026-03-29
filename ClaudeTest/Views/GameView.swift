import SwiftUI
import SwiftData

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @State private var showBudget = false

    var body: some View {
        VStack(spacing: 0) {
            // Top info bar
            InfoPanelView(viewModel: viewModel, onBudgetTap: {
                showBudget = true
            })

            // Status message
            if let status = viewModel.statusMessage {
                Text(status)
                    .font(.caption)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.1))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewModel.statusMessage = nil
                        }
                    }
            }

            // Map
            MapView(viewModel: viewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // End Turn button
            Button(action: { viewModel.advanceTurn() }) {
                HStack {
                    Image(systemName: "forward.fill")
                    Text("End Turn")
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(viewModel.city.isGameOver ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(viewModel.city.isGameOver)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)

            // Build toolbar
            BuildToolbar(viewModel: viewModel)
        }
        .sheet(isPresented: $showBudget) {
            BudgetView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showTurnSummary) {
            if let report = viewModel.lastReport {
                TurnSummaryView(report: report, cityName: viewModel.city.name)
            }
        }
        .overlay(gameOverOverlay)
    }

    @ViewBuilder
    private var gameOverOverlay: some View {
        if viewModel.city.isGameOver {
            ZStack {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("GAME OVER")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.red)

                    Text("Your city lasted \(viewModel.city.currentMonth - 1) months")
                        .foregroundColor(.white)

                    Text("Peak population: \(viewModel.city.population)")
                        .foregroundColor(.white)

                    Text("Final GDP: $\(viewModel.city.gdp)/month")
                        .foregroundColor(.white)
                }
                .padding(32)
                .background(Color.black.opacity(0.8))
                .cornerRadius(16)
            }
        }
    }
}
