import Foundation

struct Criterion: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var preponderance: Double

    var id: String {
        return nomenclature
    }

    init(nomenclature: String = UUID().uuidString, appellation: String, preponderance: Double = 0.33) {
        self.nomenclature = nomenclature
        self.appellation = appellation
        self.preponderance = preponderance
    }
}
