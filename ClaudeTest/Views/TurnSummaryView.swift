import SwiftUI

struct TurnSummaryView: View {
    let report: TurnReport
    let cityName: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Economy") {
                    HStack {
                        Text("Revenue")
                        Spacer()
                        Text("+$\(report.economyReport.totalRevenue)")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("Expenses")
                        Spacer()
                        Text("-$\(report.economyReport.maintenanceExpenses)")
                            .foregroundColor(.red)
                    }
                    HStack {
                        Text("Net Income")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(report.economyReport.netIncome >= 0 ? "+" : "")$\(report.economyReport.netIncome)")
                            .foregroundColor(report.economyReport.netIncome >= 0 ? .green : .red)
                            .fontWeight(.bold)
                    }
                }

                Section("Population") {
                    HStack {
                        Text("Change")
                        Spacer()
                        Text("\(report.populationChange >= 0 ? "+" : "")\(report.populationChange)")
                            .foregroundColor(report.populationChange >= 0 ? .green : .red)
                    }
                }

                Section("Happiness") {
                    HStack {
                        Text("Current")
                        Spacer()
                        let diff = report.happiness - report.previousHappiness
                        HStack(spacing: 4) {
                            Text("\(Int(report.happiness * 100))%")
                            if diff != 0 {
                                Text("(\(diff > 0 ? "+" : "")\(Int(diff * 100))%)")
                                    .font(.caption)
                                    .foregroundColor(diff > 0 ? .green : .red)
                            }
                        }
                    }
                }

                if !report.events.isEmpty {
                    Section("Events") {
                        ForEach(report.events, id: \.self) { event in
                            Text(event)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Monthly Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("OK") { dismiss() }
                }
            }
        }
    }
}
