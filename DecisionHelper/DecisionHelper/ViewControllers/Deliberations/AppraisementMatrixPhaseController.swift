import UIKit

class AppraisementMatrixPhaseController: UIViewController {
    private var contenderRepository: [Contender]
    private let criteriaRepository: [Criterion]
    private var onUpdateClosure: (([Contender]) -> Void)?

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate each option (1-10)"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(contenders: [Contender], criteria: [Criterion], onUpdate: @escaping ([Contender]) -> Void) {
        self.contenderRepository = contenders
        self.criteriaRepository = criteria
        self.onUpdateClosure = onUpdate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureLayout()
        initializeScores()
        configureMatrixCards()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
    }

    private func configureLayout() {
        view.addSubview(instructionLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            scrollView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * DimensionalAdaptation.horizontalMargin)
        ])
    }

    private func initializeScores() {
        for contenderIndex in contenderRepository.indices {
            for criterion in criteriaRepository {
                if contenderRepository[contenderIndex].appraisements[criterion.nomenclature] == nil {
                    contenderRepository[contenderIndex].appraisements[criterion.nomenclature] = 5.0
                }
            }
        }
        onUpdateClosure?(contenderRepository)
    }

    private func configureMatrixCards() {
        for (contenderIndex, contender) in contenderRepository.enumerated() {
            let cardView = generateContenderCardView(for: contender, at: contenderIndex)
            contentStackView.addArrangedSubview(cardView)
        }
    }

    private func generateContenderCardView(for contender: Contender, at index: Int) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = contender.appellation
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(17), weight: .bold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let criteriaStackView = UIStackView()
        criteriaStackView.axis = .vertical
        criteriaStackView.spacing = 16
        criteriaStackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(criteriaStackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            criteriaStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            criteriaStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            criteriaStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            criteriaStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        for criterion in criteriaRepository {
            let scoreRow = generateScoreRowView(contenderIndex: index, criterion: criterion)
            criteriaStackView.addArrangedSubview(scoreRow)
        }

        return containerView
    }

    private func generateScoreRowView(contenderIndex: Int, criterion: Criterion) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let criterionLabel = UILabel()
        criterionLabel.text = criterion.appellation
        criterionLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .regular)
        criterionLabel.textColor = ChromaticPalette.foregroundPearl
        criterionLabel.translatesAutoresizingMaskIntoConstraints = false

        let scoreLabel = UILabel()
        scoreLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(15), weight: .bold)
        scoreLabel.textColor = ChromaticPalette.primaryAzure
        scoreLabel.textAlignment = .right
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.tag = 1000 + contenderIndex * 100 + criteriaRepository.firstIndex(where: { $0.nomenclature == criterion.nomenclature })!

        let slider = UISlider()
        slider.minimumValue = 1.0
        slider.maximumValue = 10.0
        slider.minimumTrackTintColor = ChromaticPalette.tertiaryEmerald
        slider.maximumTrackTintColor = ChromaticPalette.separatorGraphite
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.tag = contenderIndex * 1000 + criteriaRepository.firstIndex(where: { $0.nomenclature == criterion.nomenclature })!

        let currentScore = contenderRepository[contenderIndex].appraisements[criterion.nomenclature] ?? 5.0
        slider.value = Float(currentScore)
        scoreLabel.text = String(format: "%.0f", currentScore)

        slider.addTarget(self, action: #selector(scoreSliderChanged(_:)), for: .valueChanged)

        containerView.addSubview(criterionLabel)
        containerView.addSubview(scoreLabel)
        containerView.addSubview(slider)

        NSLayoutConstraint.activate([
            criterionLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            criterionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),

            scoreLabel.centerYAnchor.constraint(equalTo: criterionLabel.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scoreLabel.widthAnchor.constraint(equalToConstant: 40),

            slider.topAnchor.constraint(equalTo: criterionLabel.bottomAnchor, constant: 8),
            slider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])

        return containerView
    }

    @objc private func scoreSliderChanged(_ sender: UISlider) {
        let contenderIndex = sender.tag / 1000
        let criterionIndex = sender.tag % 1000
        let newScore = Double(sender.value)

        let criterion = criteriaRepository[criterionIndex]
        contenderRepository[contenderIndex].appraisements[criterion.nomenclature] = newScore
        onUpdateClosure?(contenderRepository)

        if let scoreLabel = view.viewWithTag(1000 + contenderIndex * 100 + criterionIndex) as? UILabel {
            scoreLabel.text = String(format: "%.0f", newScore)
        }
    }
}
