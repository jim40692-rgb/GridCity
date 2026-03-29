import SwiftUI

struct InfoPanelView: View {
    @ObservedObject var viewModel: GameViewModel
    let onBudgetTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Date
            Text(viewModel.city.dateString)
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 70)

            Divider().frame(height: 20)

            // Population
            HStack(spacing: 2) {
                Text("👥")
                Text("\(viewModel.city.population)")
                    .font(.caption)
                    .fontWeight(.semibold)
            }

            Divider().frame(height: 20)

            // Treasury
            HStack(spacing: 2) {
                Text("💰")
                Text("$\(viewModel.city.treasury)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(viewModel.city.treasury < 0 ? .red : .primary)
            }

            Divider().frame(height: 20)

            // Happiness
            HStack(spacing: 4) {
                Text(happinessEmoji)
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                            .cornerRadius(4)
                        Rectangle()
                            .fill(happinessColor)
                            .frame(width: geometry.size.width * viewModel.city.happiness, height: 8)
                            .cornerRadius(4)
                    }
                }
                .frame(width: 50, height: 8)
                Text("\(Int(viewModel.city.happiness * 100))%")
                    .font(.system(size: 10))
            }

            Spacer()

            // Budget button
            Button(action: onBudgetTap) {
                Image(systemName: "dollarsign.circle")
                    .font(.title3)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground).shadow(radius: 1))
    }

    private var happinessColor: Color {
        if viewModel.city.happiness > 0.6 { return .green }
        if viewModel.city.happiness > 0.4 { return .yellow }
        return .red
    }

    private var happinessEmoji: String {
        if viewModel.city.happiness > 0.7 { return "😊" }
        if viewModel.city.happiness > 0.4 { return "😐" }
        return "😡"
    }
}
