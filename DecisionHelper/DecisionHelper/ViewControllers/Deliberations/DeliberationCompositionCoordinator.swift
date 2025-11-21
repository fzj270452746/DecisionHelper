import UIKit

class DeliberationCompositionCoordinator: UIViewController {
    enum CompositionPhase: Int, CaseIterable {
        case fundamentalConfiguration
        case contenderSpecification
        case criterionDesignation
        case preponderanceAllocation
        case appraisementMatrix

        var appellationText: String {
            switch self {
            case .fundamentalConfiguration: return "Basic Info"
            case .contenderSpecification: return "Options"
            case .criterionDesignation: return "Criteria"
            case .preponderanceAllocation: return "Weights"
            case .appraisementMatrix: return "Scores"
            }
        }
    }

    var onCompletionClosure: ((Deliberation) -> Void)?

    private var currentPhase: CompositionPhase = .fundamentalConfiguration
    private var deliberationTitle: String = ""
    private var contenders: [Contender] = []
    private var criteria: [Criterion] = [
        Criterion(appellation: "Cost", preponderance: 0.33),
        Criterion(appellation: "Time", preponderance: 0.33),
        Criterion(appellation: "Risk", preponderance: 0.34)
    ]

    private let phaseIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let phaseDotsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let proceedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(17), weight: .semibold)
        button.backgroundColor = ChromaticPalette.primaryAzure
        button.setTitleColor(ChromaticPalette.foregroundIvory, for: .normal)
        button.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureNavigationBar()
        configurePhaseIndicator()
        configureLayout()
        manifestPhase(currentPhase)
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        title = "New Decision"
    }

    private func configureNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissComposition))
        navigationItem.leftBarButtonItem = cancelButton
    }

    private func configurePhaseIndicator() {
        view.addSubview(phaseIndicatorView)
        phaseIndicatorView.addSubview(phaseDotsStackView)

        NSLayoutConstraint.activate([
            phaseIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            phaseIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            phaseIndicatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            phaseIndicatorView.heightAnchor.constraint(equalToConstant: 50),

            phaseDotsStackView.centerXAnchor.constraint(equalTo: phaseIndicatorView.centerXAnchor),
            phaseDotsStackView.centerYAnchor.constraint(equalTo: phaseIndicatorView.centerYAnchor)
        ])

        for phase in CompositionPhase.allCases {
            let dotView = generatePhaseDotView(for: phase)
            phaseDotsStackView.addArrangedSubview(dotView)
        }
    }

    private func generatePhaseDotView(for phase: CompositionPhase) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let dotView = UIView()
        dotView.backgroundColor = phase.rawValue <= currentPhase.rawValue ? ChromaticPalette.primaryAzure : ChromaticPalette.foregroundAsh
        dotView.layer.cornerRadius = 6
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.tag = 100 + phase.rawValue

        container.addSubview(dotView)

        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 12),
            dotView.heightAnchor.constraint(equalToConstant: 12),
            dotView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            dotView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 20),
            container.heightAnchor.constraint(equalToConstant: 20)
        ])

        return container
    }

    private func configureLayout() {
        view.addSubview(containerView)
        view.addSubview(proceedButton)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: phaseIndicatorView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: proceedButton.topAnchor, constant: -16),

            proceedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            proceedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            proceedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            proceedButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        proceedButton.addTarget(self, action: #selector(proceedToNextPhase), for: .touchUpInside)
    }

    private func manifestPhase(_ phase: CompositionPhase) {
        containerView.subviews.forEach { $0.removeFromSuperview() }

        let phaseViewController: UIViewController

        switch phase {
        case .fundamentalConfiguration:
            phaseViewController = FundamentalConfigurationPhaseController(existingTitle: deliberationTitle) { [weak self] title in
                self?.deliberationTitle = title
            }
        case .contenderSpecification:
            phaseViewController = ContenderSpecificationPhaseController(existingContenders: contenders) { [weak self] updatedContenders in
                self?.contenders = updatedContenders
            }
        case .criterionDesignation:
            phaseViewController = CriterionDesignationPhaseController(existingCriteria: criteria) { [weak self] updatedCriteria in
                self?.criteria = updatedCriteria
            }
        case .preponderanceAllocation:
            phaseViewController = PreponderanceAllocationPhaseController(criteria: criteria) { [weak self] updatedCriteria in
                self?.criteria = updatedCriteria
            }
        case .appraisementMatrix:
            phaseViewController = AppraisementMatrixPhaseController(contenders: contenders, criteria: criteria) { [weak self] updatedContenders in
                self?.contenders = updatedContenders
            }
        }

        addChild(phaseViewController)
        containerView.addSubview(phaseViewController.view)
        phaseViewController.view.frame = containerView.bounds
        phaseViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        phaseViewController.didMove(toParent: self)

        updatePhaseIndicator()
        updateProceedButton()
    }

    private func updatePhaseIndicator() {
        for phase in CompositionPhase.allCases {
            if let dotView = phaseDotsStackView.viewWithTag(100 + phase.rawValue) {
                UIView.animate(withDuration: 0.3) {
                    dotView.backgroundColor = phase.rawValue <= self.currentPhase.rawValue ? ChromaticPalette.primaryAzure : ChromaticPalette.foregroundAsh
                }
            }
        }
    }

    private func updateProceedButton() {
        if currentPhase == .appraisementMatrix {
            proceedButton.setTitle("Generate Result", for: .normal)
            proceedButton.backgroundColor = ChromaticPalette.tertiaryEmerald
        } else {
            proceedButton.setTitle("Continue", for: .normal)
            proceedButton.backgroundColor = ChromaticPalette.primaryAzure
        }
    }

    @objc private func proceedToNextPhase() {
        if currentPhase == .appraisementMatrix {
            completeComposition()
        } else if let nextPhase = CompositionPhase(rawValue: currentPhase.rawValue + 1) {
            currentPhase = nextPhase
            manifestPhase(currentPhase)
        }
    }

    private func completeComposition() {
        let deliberation = Deliberation(
            appellation: deliberationTitle.isEmpty ? "Untitled Decision" : deliberationTitle,
            contenders: contenders,
            criteria: criteria
        )

        onCompletionClosure?(deliberation)
        dismiss(animated: true)
    }

    @objc private func dismissComposition() {
        dismiss(animated: true)
    }
}
