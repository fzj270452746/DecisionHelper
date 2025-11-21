import Foundation

struct Contender: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var elucidation: String?
    var appraisements: [String: Double]

    var id: String {
        return nomenclature
    }

    init(nomenclature: String = UUID().uuidString, appellation: String, elucidation: String? = nil, appraisements: [String: Double] = [:]) {
        self.nomenclature = nomenclature
        self.appellation = appellation
        self.elucidation = elucidation
        self.appraisements = appraisements
    }

    func calculateAggregatedValuation(with criteria: [Criterion]) -> Double {
        var summation: Double = 0.0
        for criterion in criteria {
            if let appraisement = appraisements[criterion.nomenclature] {
                summation += appraisement * criterion.preponderance
            }
        }
        return summation * 10.0
    }
}
