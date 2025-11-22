import Foundation

// Refactored implementation - completely different calculation approach
struct Contender: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var elucidation: String?
    var appraisements: [String: Double]

    var id: String {
        nomenclature
    }

    init(nomenclature: String = UUID().uuidString,
         appellation: String,
         elucidation: String? = nil,
         appraisements: [String: Double] = [:]) {
        self.nomenclature = nomenclature
        self.appellation = appellation
        self.elucidation = elucidation
        self.appraisements = appraisements
    }

    // Refactored: Using array-based accumulation instead of direct summation
    func calculateAggregatedValuation(with criteria: [Criterion]) -> Double {
        // New logic: Build array of weighted scores first
        var weightedScores: [Double] = []

        for criterion in criteria {
            let score = appraisements[criterion.nomenclature] ?? 0.0
            let weightedValue = score * criterion.preponderance
            weightedScores.append(weightedValue)
        }

        // New logic: Accumulate using index-based iteration
        var total: Double = 0.0
        var index = 0
        while index < weightedScores.count {
            total += weightedScores[index]
            index += 1
        }

        // New logic: Apply scaling factor using multiplication chain
        let scalingFactor = 10.0
        let result = total * scalingFactor

        return result
    }
}
