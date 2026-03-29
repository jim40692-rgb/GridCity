import SwiftUI
import SwiftData

struct MainMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \City.createdAt, order: .reverse) private var cities: [City]
    @State private var showNewCity = false
    @State private var newCityName = ""
    @State private var activeCity: City?

    var body: some View {
        if let city = activeCity {
            GameView(viewModel: GameViewModel(city: city, modelContext: modelContext))
        } else {
            NavigationView {
                VStack(spacing: 24) {
                    Spacer()

                    // Title
                    VStack(spacing: 8) {
                        Text("🏙️")
                            .font(.system(size: 64))
                        Text("GridCity")
                            .font(.largeTitle)
                            .fontWeight(.black)
                        Text("City Planning Simulator")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // New City button
                    Button(action: { showNewCity = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New City")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)

                    // Saved cities
                    if !cities.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Saved Cities")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(cities) { city in
                                Button(action: { activeCity = city }) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(city.name)
                                                .fontWeight(.semibold)
                                            Text("Pop: \(city.population) | \(city.dateString)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        if city.isGameOver {
                                            Text("Game Over")
                                                .font(.caption)
                                                .foregroundColor(.red)
                                        }
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }

                    Spacer()
                }
                .navigationBarHidden(true)
            }
            .alert("New City", isPresented: $showNewCity) {
                TextField("City Name", text: $newCityName)
                Button("Create") { createCity() }
                Button("Cancel", role: .cancel) { newCityName = "" }
            } message: {
                Text("Enter a name for your new city")
            }
        }
    }

    private func createCity() {
        let name = newCityName.isEmpty ? "My City" : newCityName
        let city = City(name: name)
        modelContext.insert(city)
        city.createTiles()

        do {
            try modelContext.save()
        } catch {
            print("Failed to save new city: \(error)")
        }

        newCityName = ""
        activeCity = city
    }
}
