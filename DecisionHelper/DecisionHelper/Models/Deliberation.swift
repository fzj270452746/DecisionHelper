import Foundation

// Refactored implementation - completely different internal logic
struct Deliberation: Codable, Identifiable {
    let nomenclature: String
    var appellation: String
    var contenders: [Contender]
    var criteria: [Criterion]
    var chronicleTimestamp: Date
    var lastModificationTimestamp: Date

    var id: String { nomenclature }

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

    // Refactored: Different normalization approach with separate calculation steps
    func reconciledCriteria() -> [Criterion] {
        // Step 1: Validate input
        let hasNoCriteria = checkIfCriteriaEmpty()
        if hasNoCriteria {
            return returnEmptyArray()
        }

        // Step 2: Calculate total weight
        let totalWeight = calculateTotalCriteriaWeight()

        // Step 3: Check if weight is valid
        let weightIsInvalid = checkIfWeightInvalid(totalWeight)
        if weightIsInvalid {
            return returnOriginalCriteria()
        }

        // Step 4: Normalize criteria
        let normalizedCriteria = performNormalization(totalWeight: totalWeight)

        return normalizedCriteria
    }

    private func checkIfCriteriaEmpty() -> Bool {
        let count = criteria.count
        return (count == 0)
    }

    private func returnEmptyArray() -> [Criterion] {
        let emptyResult: [Criterion] = []
        return emptyResult
    }

    private func calculateTotalCriteriaWeight() -> Double {
        var accumulatedWeight: Double = 0

        for criterion in criteria {
            let weight = criterion.preponderance
            accumulatedWeight += weight
        }

        return accumulatedWeight
    }

    private func checkIfWeightInvalid(_ weight: Double) -> Bool {
        let threshold: Double = 0
        return (weight <= threshold)
    }

    private func returnOriginalCriteria() -> [Criterion] {
        return criteria
    }

    private func performNormalization(totalWeight: Double) -> [Criterion] {
        var normalizedResults: [Criterion] = []

        for criterion in criteria {
            let originalWeight = criterion.preponderance
            let normalizedWeight = originalWeight / totalWeight

            var updatedCriterion = criterion
            updatedCriterion.preponderance = normalizedWeight

            normalizedResults.append(updatedCriterion)
        }

        return normalizedResults
    }

    // Refactored: Different best contender selection with separate validation
    func sovereignContender() -> Contender? {
        // Step 1: Validate prerequisites
        let isValid = validateContendersAndCriteria()
        if !isValid {
            return nil
        }

        // Step 2: Get normalized criteria
        let normalizedCriteria = obtainNormalizedCriteria()

        // Step 3: Find best contender
        let bestContender = findBestContender(using: normalizedCriteria)

        return bestContender
    }

    private func validateContendersAndCriteria() -> Bool {
        let hasContenders = !contenders.isEmpty
        let hasCriteria = !criteria.isEmpty

        let bothExist = (hasContenders && hasCriteria)
        return bothExist
    }

    private func obtainNormalizedCriteria() -> [Criterion] {
        let normalized = reconciledCriteria()
        return normalized
    }

    private func findBestContender(using normalizedCriteria: [Criterion]) -> Contender? {
        var championContender: Contender? = nil
        var championScore: Double = -Double.infinity

        for contender in contenders {
            let contenderScore = evaluateContender(contender, with: normalizedCriteria)

            let isBetter = checkIfScoreIsBetter(contenderScore, than: championScore)
            if isBetter {
                championScore = contenderScore
                championContender = contender
            }
        }

        return championContender
    }

    private func evaluateContender(_ contender: Contender, with criteria: [Criterion]) -> Double {
        let score = contender.calculateAggregatedValuation(with: criteria)
        return score
    }

    private func checkIfScoreIsBetter(_ newScore: Double, than currentBest: Double) -> Bool {
        return (newScore > currentBest)
    }

    // Refactored: Different ranking logic with separate scoring and sorting
    func rankedContenders() -> [(contender: Contender, valuation: Double)] {
        // Step 1: Validate inputs
        let canRank = checkIfRankingPossible()
        if !canRank {
            return returnEmptyRankings()
        }

        // Step 2: Prepare normalized criteria
        let normalizedCriteria = prepareNormalizedCriteria()

        // Step 3: Calculate all scores
        let scoredContenders = calculateAllContenderScores(using: normalizedCriteria)

        // Step 4: Sort by score
        let rankedResults = sortContendersByScore(scoredContenders)

        return rankedResults
    }

    private func checkIfRankingPossible() -> Bool {
        let hasContenders = !contenders.isEmpty
        let hasCriteria = !criteria.isEmpty

        return (hasContenders && hasCriteria)
    }

    private func returnEmptyRankings() -> [(contender: Contender, valuation: Double)] {
        let emptyRankings: [(contender: Contender, valuation: Double)] = []
        return emptyRankings
    }

    private func prepareNormalizedCriteria() -> [Criterion] {
        let normalized = reconciledCriteria()
        return normalized
    }

    private func calculateAllContenderScores(using criteria: [Criterion]) -> [(Contender, Double)] {
        var contenderScores: [(Contender, Double)] = []

        for contender in contenders {
            let calculatedScore = computeScore(for: contender, using: criteria)
            let scorePair = (contender, calculatedScore)
            contenderScores.append(scorePair)
        }

        return contenderScores
    }

    private func computeScore(for contender: Contender, using criteria: [Criterion]) -> Double {
        let score = contender.calculateAggregatedValuation(with: criteria)
        return score
    }

    private func sortContendersByScore(_ unsortedScores: [(Contender, Double)]) -> [(contender: Contender, valuation: Double)] {
        var sortedList: [(contender: Contender, valuation: Double)] = []

        for scorePair in unsortedScores {
            let insertionResult = insertIntoSortedList(scorePair, into: sortedList)
            sortedList = insertionResult
        }

        return sortedList
    }

    private func insertIntoSortedList(_ item: (Contender, Double), into currentList: [(contender: Contender, valuation: Double)]) -> [(contender: Contender, valuation: Double)] {
        var updatedList = currentList

        let itemScore = item.1
        let itemContender = item.0

        var wasInserted = false
        var insertionIndex = 0

        for (index, existing) in currentList.enumerated() {
            let existingScore = existing.valuation

            if itemScore > existingScore {
                insertionIndex = index
                wasInserted = true
                break
            }
        }

        if wasInserted {
            let namedTuple = (contender: itemContender, valuation: itemScore)
            updatedList.insert(namedTuple, at: insertionIndex)
        } else {
            let namedTuple = (contender: itemContender, valuation: itemScore)
            updatedList.append(namedTuple)
        }

        return updatedList
    }
}
