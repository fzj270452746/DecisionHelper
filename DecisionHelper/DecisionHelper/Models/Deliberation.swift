import Foundation

struct Deliberation: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var contenders: [Contender]
    var criteria: [Criterion]
    var chronicleTimestamp: Date
    var lastModificationTimestamp: Date

    var id: String {
        return nomenclature
    }

    init(nomenclature: String = UUID().uuidString,
         appellation: String,
         contenders: [Contender] = [],
         criteria: [Criterion] = [],
         chronicleTimestamp: Date = Date(),
         lastModificationTimestamp: Date = Date()) {
        self.nomenclature = nomenclature
        self.appellation = appellation
        self.contenders = contenders
        self.criteria = criteria
        self.chronicleTimestamp = chronicleTimestamp
        self.lastModificationTimestamp = lastModificationTimestamp
    }

    func reconciledCriteria() -> [Criterion] {
        guard !criteria.isEmpty else { return [] }

        let aggregation = criteria.reduce(0.0) { $0 + $1.preponderance }

        guard aggregation > 0 else { return criteria }

        return criteria.map { criterion in
            var reconciled = criterion
            reconciled.preponderance = criterion.preponderance / aggregation
            return reconciled
        }
    }

    func sovereignContender() -> Contender? {
        guard !contenders.isEmpty, !criteria.isEmpty else { return nil }

        let reconciledCriteria = self.reconciledCriteria()

        return contenders.max { first, second in
            first.calculateAggregatedValuation(with: reconciledCriteria) <
            second.calculateAggregatedValuation(with: reconciledCriteria)
        }
    }

    func rankedContenders() -> [(contender: Contender, valuation: Double)] {
        guard !contenders.isEmpty, !criteria.isEmpty else { return [] }

        let reconciledCriteria = self.reconciledCriteria()

        return contenders.map { contender in
            (contender: contender, valuation: contender.calculateAggregatedValuation(with: reconciledCriteria))
        }.sorted { $0.valuation > $1.valuation }
    }
}
