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

    // Refactored: Different initialization flow and method call sequence
    override func viewDidLoad() {
        super.viewDidLoad()

        // New logic: Setup in different order with intermediate steps
        performInitialSetup()
    }

    private func performInitialSetup() {
        // Step 1: Configure visual appearance first
        setupVisualConfiguration()

        // Step 2: Setup navigation components
        setupNavigationComponents()

        // Step 3: Build UI hierarchy
        buildUserInterfaceHierarchy()

        // Step 4: Display initial content
        displayInitialPhaseContent()
    }

    private func setupVisualConfiguration() {
        configureAppearance()
    }

    private func setupNavigationComponents() {
        configureNavigationBar()
    }

    private func buildUserInterfaceHierarchy() {
        configurePhaseIndicator()
        configureLayout()
    }

    private func displayInitialPhaseContent() {
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

    // Refactored: Different phase manifestation flow with separate concerns
    private func manifestPhase(_ phase: CompositionPhase) {
        // Step 1: Prepare container
        prepareContainerForNewPhase()

        // Step 2: Create phase controller
        let phaseViewController = createPhaseViewController(for: phase)

        // Step 3: Install controller into view hierarchy
        installChildViewController(phaseViewController)

        // Step 4: Update UI indicators
        refreshUserInterfaceIndicators()
    }

    private func prepareContainerForNewPhase() {
        // New logic: Manual removal of subviews
        let subviewsToRemove = containerView.subviews
        for subview in subviewsToRemove {
            subview.removeFromSuperview()
        }
    }

    private func createPhaseViewController(for phase: CompositionPhase) -> UIViewController {
        // New logic: Separate method for controller creation
        var controller: UIViewController

        let phaseType = phase
        switch phaseType {
        case .fundamentalConfiguration:
            controller = buildFundamentalConfigurationController()
        case .contenderSpecification:
            controller = buildContenderSpecificationController()
        case .criterionDesignation:
            controller = buildCriterionDesignationController()
        case .preponderanceAllocation:
            controller = buildPreponderanceAllocationController()
        case .appraisementMatrix:
            controller = buildAppraisementMatrixController()
        }

        return controller
    }

    private func buildFundamentalConfigurationController() -> UIViewController {
        let controller = FundamentalConfigurationPhaseController(existingTitle: deliberationTitle) { [weak self] title in
            self?.deliberationTitle = title
        }
        return controller
    }

    private func buildContenderSpecificationController() -> UIViewController {
        let controller = ContenderSpecificationPhaseController(existingContenders: contenders) { [weak self] updatedContenders in
            self?.contenders = updatedContenders
        }
        return controller
    }

    private func buildCriterionDesignationController() -> UIViewController {
        let controller = CriterionDesignationPhaseController(existingCriteria: criteria) { [weak self] updatedCriteria in
            self?.criteria = updatedCriteria
        }
        return controller
    }

    private func buildPreponderanceAllocationController() -> UIViewController {
        let controller = PreponderanceAllocationPhaseController(criteria: criteria) { [weak self] updatedCriteria in
            self?.criteria = updatedCriteria
        }
        return controller
    }

    private func buildAppraisementMatrixController() -> UIViewController {
        let controller = AppraisementMatrixPhaseController(contenders: contenders, criteria: criteria) { [weak self] updatedContenders in
            self?.contenders = updatedContenders
        }
        return controller
    }

    private func installChildViewController(_ childController: UIViewController) {
        // New logic: Step-by-step installation
        addChild(childController)

        let childView = childController.view!
        containerView.addSubview(childView)

        childView.frame = containerView.bounds
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        childController.didMove(toParent: self)
    }

    private func refreshUserInterfaceIndicators() {
        // New logic: Separate method for UI updates
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

    // Refactored: Different progression logic with validation and state management
    @objc private func proceedToNextPhase() {
        // New logic: Check completion status first
        let isOnFinalPhase = checkIfOnFinalPhase()

        if isOnFinalPhase {
            handleCompositionCompletion()
        } else {
            advanceToNextPhase()
        }
    }

    private func checkIfOnFinalPhase() -> Bool {
        let finalPhase = CompositionPhase.appraisementMatrix
        let currentIsLast = (currentPhase == finalPhase)
        return currentIsLast
    }

    private func handleCompositionCompletion() {
        completeComposition()
    }

    private func advanceToNextPhase() {
        // New logic: Calculate next phase manually
        let currentRawValue = currentPhase.rawValue
        let nextRawValue = currentRawValue + 1

        // Try to create next phase
        if let calculatedNextPhase = CompositionPhase(rawValue: nextRawValue) {
            transitionToPhase(calculatedNextPhase)
        }
    }

    private func transitionToPhase(_ targetPhase: CompositionPhase) {
        // New logic: Update state then render
        currentPhase = targetPhase
        renderCurrentPhase()
    }

    private func renderCurrentPhase() {
        manifestPhase(currentPhase)
    }

    private func completeComposition() {
        // New logic: Build deliberation in steps
        let finalTitle = determineFinalTitle()
        let finalContenders = contenders
        let finalCriteria = criteria

        let completedDeliberation = constructDeliberation(
            title: finalTitle,
            contenders: finalContenders,
            criteria: finalCriteria
        )

        notifyCompletionAndDismiss(completedDeliberation)
    }

    private func determineFinalTitle() -> String {
        let enteredTitle = deliberationTitle
        let titleIsEmpty = enteredTitle.isEmpty

        if titleIsEmpty {
            return "Untitled Decision"
        } else {
            return enteredTitle
        }
    }

    private func constructDeliberation(title: String, contenders: [Contender], criteria: [Criterion]) -> Deliberation {
        let newDeliberation = Deliberation(
            appellation: title,
            contenders: contenders,
            criteria: criteria
        )
        return newDeliberation
    }

    private func notifyCompletionAndDismiss(_ deliberation: Deliberation) {
        // New logic: Notify callback first
        if let completionHandler = onCompletionClosure {
            completionHandler(deliberation)
        }

        // Then dismiss
        performDismissal()
    }

    private func performDismissal() {
        dismiss(animated: true)
    }

    @objc private func dismissComposition() {
        dismiss(animated: true)
    }
}
