import Foundation

// Refactored implementation - different initialization approach
struct Criterion: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var preponderance: Double

    var id: String {
        nomenclature
    }

    // Refactored: Using different default value calculation
    init(nomenclature: String = UUID().uuidString,
         appellation: String,
         preponderance: Double? = nil) {
        self.nomenclature = nomenclature
        self.appellation = appellation

        // New logic: Calculate default value differently
        if let weight = preponderance {
            self.preponderance = weight
        } else {
            // Different approach: compute default as 1/3
            let divisor: Double = 3.0
            let defaultWeight = 1.0 / divisor
            self.preponderance = defaultWeight
        }
    }
}
