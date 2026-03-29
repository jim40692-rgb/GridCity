import SwiftUI

struct BudgetView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Tax Rates") {
                    taxSlider(label: "Residential", emoji: "🏠",
                              rate: $viewModel.city.residentialTaxRate)
                    taxSlider(label: "Commercial", emoji: "🏪",
                              rate: $viewModel.city.commercialTaxRate)
                    taxSlider(label: "Industrial", emoji: "🏭",
                              rate: $viewModel.city.industrialTaxRate)
                }

                Section("Monthly Revenue") {
                    let report = viewModel.currentEconomyReport
                    HStack {
                        Text("🏠 Residential")
                        Spacer()
                        Text("+$\(report.residentialRevenue)")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("🏪 Commercial")
                        Spacer()
                        Text("+$\(report.commercialRevenue)")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("🏭 Industrial")
                        Spacer()
                        Text("+$\(report.industrialRevenue)")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("Total Revenue")
                            .fontWeight(.bold)
                        Spacer()
                        Text("+$\(report.totalRevenue)")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                    }
                }

                Section("Monthly Expenses") {
                    let report = viewModel.currentEconomyReport
                    HStack {
                        Text("Maintenance")
                        Spacer()
                        Text("-$\(report.maintenanceExpenses)")
                            .foregroundColor(.red)
                    }
                }

                Section("Summary") {
                    let report = viewModel.currentEconomyReport
                    HStack {
                        Text("Net Income")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(report.netIncome >= 0 ? "+" : "")$\(report.netIncome)")
                            .foregroundColor(report.netIncome >= 0 ? .green : .red)
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Treasury")
                        Spacer()
                        Text("$\(viewModel.city.treasury)")
                            .foregroundColor(viewModel.city.treasury >= 0 ? .primary : .red)
                    }
                }
            }
            .navigationTitle("Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func taxSlider(label: String, emoji: String, rate: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(emoji) \(label)")
                Spacer()
                Text("\(Int(rate.wrappedValue * 100))%")
                    .fontWeight(.semibold)
            }
            Slider(value: rate,
                   in: GameConstants.minTaxRate...GameConstants.maxTaxRate,
                   step: 0.01)
        }
    }
}
