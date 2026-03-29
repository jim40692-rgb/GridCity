import Foundation

struct GameConstants {
    static let gridWidth = 20
    static let gridHeight = 20
    static let startingTreasury = 10000
    static let startingPopulation = 0
    static let startingHappiness = 0.7

    static let defaultResidentialTax = 0.10
    static let defaultCommercialTax = 0.10
    static let defaultIndustrialTax = 0.12
    static let maxTaxRate = 0.30
    static let minTaxRate = 0.0

    static let gameOverHappinessThreshold = 0.20
    static let gameOverUnhappyStreakLimit = 3
    static let gameOverDebtLimit = -5000

    // Population per zone development level
    static let residentialPopPerLevel = [0, 50, 200, 500]
    // Jobs per zone development level
    static let commercialJobsPerLevel = [0, 30, 120, 300]
    static let industrialJobsPerLevel = [0, 40, 150, 350]

    // Revenue per unit per tax point
    static let residentialRevenuePerPop = 10
    static let commercialRevenuePerJob = 15
    static let industrialRevenuePerJob = 20

    // Happiness weights (must sum to 1.0)
    static let happinessWeightTax = 0.20
    static let happinessWeightServices = 0.20
    static let happinessWeightPollution = 0.15
    static let happinessWeightParks = 0.10
    static let happinessWeightTransit = 0.10
    static let happinessWeightCommute = 0.10
    static let happinessWeightUtilities = 0.15

    // Zone development
    static let baseDevelopmentChance = 0.3
    static let maxDevelopmentLevel = 3

    // Population growth
    static let basePopulationGrowthRate = 0.05
    static let unhappinessPopulationDeclineRate = 0.03

    // Demolish refund rate
    static let demolishRefundRate = 0.5

    // Tile size for rendering
    static let tileSize: CGFloat = 32
}
