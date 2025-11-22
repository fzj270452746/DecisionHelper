import UIKit

class DeliberationVeracityViewController: UIViewController {
    private let deliberation: Deliberation

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let recommendationBannerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusAmplified
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let radarChartVisualization: RadarChartVisualization = {
        let chart = RadarChartVisualization()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    init(deliberation: Deliberation) {
        self.deliberation = deliberation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureLayout()
        populateContent()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        title = "Results"

        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareResults))
        navigationItem.rightBarButtonItem = shareButton
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * DimensionalAdaptation.horizontalMargin)
        ])
    }

    private func populateContent() {
        contentStackView.addArrangedSubview(generateRecommendationBanner())
        contentStackView.addArrangedSubview(generateRadarChartSection())
        contentStackView.addArrangedSubview(generateRankingTableSection())
        contentStackView.addArrangedSubview(generateAnalysisSection())
    }

    private func generateRecommendationBanner() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusAmplified
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.applyGradientEmbellishment(
            startingChroma: ChromaticPalette.primaryAzure.withAlphaComponent(0.3),
            terminatingChroma: ChromaticPalette.secondaryViolet.withAlphaComponent(0.3)
        )

        let iconLabel = UILabel()
        iconLabel.text = "★"
        iconLabel.font = UIFont.systemFont(ofSize: 50)
        iconLabel.textColor = ChromaticPalette.warningAmber
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let recommendationLabel = UILabel()
        recommendationLabel.text = "Recommended"
        recommendationLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .medium)
        recommendationLabel.textColor = ChromaticPalette.foregroundAsh
        recommendationLabel.textAlignment = .center
        recommendationLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        if let sovereign = deliberation.sovereignContender() {
            titleLabel.text = sovereign.appellation
        } else {
            titleLabel.text = "No recommendation"
        }
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(26), weight: .bold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let scoreLabel = UILabel()
        if let sovereign = deliberation.sovereignContender() {
            let score = sovereign.calculateAggregatedValuation(with: deliberation.reconciledCriteria())
            scoreLabel.text = String(format: "%.0f / 100", score)
        } else {
            scoreLabel.text = "N/A"
        }
        scoreLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(32), weight: .black)
        scoreLabel.textColor = ChromaticPalette.tertiaryEmerald
        scoreLabel.textAlignment = .center
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(iconLabel)
        containerView.addSubview(recommendationLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            iconLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            recommendationLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 12),
            recommendationLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: recommendationLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scoreLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),

            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 240)
        ])

        containerView.applyShadowEmbellishment(opacity: 0.3, radius: 12)

        return containerView
    }

    private func generateRadarChartSection() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Comparison Chart"
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(radarChartVisualization)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            radarChartVisualization.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            radarChartVisualization.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            radarChartVisualization.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            radarChartVisualization.heightAnchor.constraint(equalToConstant: 280),
            radarChartVisualization.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        radarChartVisualization.configureDatasets(contenders: deliberation.contenders, criteria: deliberation.criteria)

        return containerView
    }

    private func generateRankingTableSection() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Rankings"
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        let rankedContenders = deliberation.rankedContenders()
        for (index, ranking) in rankedContenders.enumerated() {
            let rowView = generateRankingRow(rank: index + 1, contender: ranking.contender, score: ranking.valuation)
            stackView.addArrangedSubview(rowView)
        }

        return containerView
    }

    private func generateRankingRow(rank: Int, contender: Contender, score: Double) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundSlate
        containerView.layer.cornerRadius = 8
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let rankLabel = UILabel()
        rankLabel.text = "#\(rank)"
        rankLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .bold)
        rankLabel.textColor = rank == 1 ? ChromaticPalette.warningAmber : ChromaticPalette.foregroundAsh
        rankLabel.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = contender.appellation
        nameLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(15), weight: .semibold)
        nameLabel.textColor = ChromaticPalette.foregroundIvory
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let scoreLabel = UILabel()
        scoreLabel.text = String(format: "%.0f", score)
        scoreLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .bold)
        scoreLabel.textColor = ChromaticPalette.tertiaryEmerald
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(rankLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(scoreLabel)

        NSLayoutConstraint.activate([
            rankLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            rankLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            rankLabel.widthAnchor.constraint(equalToConstant: 40),

            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            scoreLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])

        return containerView
    }

    private func generateAnalysisSection() -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "Analysis"
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let analysisLabel = UILabel()
        analysisLabel.numberOfLines = 0
        analysisLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .regular)
        analysisLabel.textColor = ChromaticPalette.foregroundPearl
        analysisLabel.translatesAutoresizingMaskIntoConstraints = false

        if let sovereign = deliberation.sovereignContender() {
            let rankedContenders = deliberation.rankedContenders()
            analysisLabel.text = generateAnalysisNarrative(sovereign: sovereign, rankings: rankedContenders)
        } else {
            analysisLabel.text = "Unable to generate analysis due to insufficient data."
        }

        containerView.addSubview(titleLabel)
        containerView.addSubview(analysisLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            analysisLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            analysisLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            analysisLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            analysisLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        return containerView
    }

    // Refactored: Different narrative generation logic
    private func generateAnalysisNarrative(sovereign: Contender, rankings: [(contender: Contender, valuation: Double)]) -> String {
        // New logic: Build narrative piece by piece
        var narrativeParts: [String] = []

        // First part: base recommendation
        let basePart = "Based on your criteria, \(sovereign.appellation) emerges as the optimal choice"
        narrativeParts.append(basePart)

        // Second part: score comparison (if applicable)
        let rankingCount = rankings.count
        if rankingCount > 1 {
            let firstScore = rankings[0].valuation
            let secondScore = rankings[1].valuation
            let scoreDifference = firstScore - secondScore

            // Manual threshold check
            let threshold: Double = 5.0
            let isClose = (scoreDifference < threshold)

            var comparisonPart: String
            if isClose {
                let secondName = rankings[1].contender.appellation
                let formattedDiff = String(format: "%.1f", scoreDifference)
                comparisonPart = ", though \(secondName) is a close alternative with only a \(formattedDiff) point difference"
            } else {
                let formattedDiff = String(format: "%.1f", scoreDifference)
                comparisonPart = " with a significant \(formattedDiff) point advantage over the second option"
            }

            narrativeParts.append(comparisonPart)
        }

        // Third part: top criterion (manual iteration to find max)
        var maxCriterion: Criterion? = nil
        var maxWeight: Double = -1.0

        for criterion in deliberation.criteria {
            let currentWeight = criterion.preponderance
            if currentWeight > maxWeight {
                maxWeight = currentWeight
                maxCriterion = criterion
            }
        }

        if let criterion = maxCriterion {
            let lowercaseName = criterion.appellation.lowercased()
            let influencePart = ". The decision is most influenced by \(lowercaseName)"
            narrativeParts.append(influencePart)
        }

        // Final part: period
        narrativeParts.append(".")

        // New logic: Manual string concatenation
        var finalNarrative = ""
        for part in narrativeParts {
            finalNarrative += part
        }

        return finalNarrative
    }

    // Refactored: Different share text building logic
    @objc private func shareResults() {
        // New logic: Build share text in parts
        var textComponents: [String] = []

        // Part 1: Decision title
        let titlePart = "Decision: \(deliberation.appellation)"
        textComponents.append(titlePart)
        textComponents.append("\n\n")

        // Part 2: Recommendation (if available)
        let bestOption = deliberation.sovereignContender()
        if let sovereign = bestOption {
            let normalizedCriteria = deliberation.reconciledCriteria()
            let calculatedScore = sovereign.calculateAggregatedValuation(with: normalizedCriteria)
            let formattedScore = String(format: "%.0f", calculatedScore)

            let recommendationPart = "Recommended: \(sovereign.appellation) (\(formattedScore)/100)"
            textComponents.append(recommendationPart)
            textComponents.append("\n\n")
        }

        // Part 3: Rankings header
        textComponents.append("Rankings:\n")

        // Part 4: Rankings list (manual iteration)
        let rankedList = deliberation.rankedContenders()
        var position = 1

        for ranking in rankedList {
            let optionName = ranking.contender.appellation
            let optionScore = ranking.valuation
            let formattedScore = String(format: "%.0f", optionScore)

            let rankingLine = "\(position). \(optionName) - \(formattedScore)\n"
            textComponents.append(rankingLine)

            position += 1
        }

        // New logic: Concatenate all parts manually
        var finalText = ""
        for component in textComponents {
            finalText += component
        }

        let activityController = UIActivityViewController(activityItems: [finalText], applicationActivities: nil)
        present(activityController, animated: true)
    }
}
