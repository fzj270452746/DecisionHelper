import UIKit

class RapidDeliberationViewController: UIViewController {
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

    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Quick Decision"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(28), weight: .bold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Use templates or random choice"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(15), weight: .regular)
        label.textColor = ChromaticPalette.foregroundAsh
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureLayout()
        populateTemplates()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        title = "Rapid"
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

        contentStackView.addArrangedSubview(headerLabel)
        contentStackView.addArrangedSubview(subtitleLabel)
    }

    private func populateTemplates() {
        let templates = [
            RapidTemplate(
                iconGlyph: "🍽️",
                appellation: "Restaurant Choice",
                elucidation: "Decide where to eat",
                chromaGradient: (ChromaticPalette.accentCrimson, ChromaticPalette.warningAmber),
                criteria: ["Price", "Distance", "Quality"],
                sampleContenders: ["Italian", "Japanese", "Mexican"]
            ),
            RapidTemplate(
                iconGlyph: "🛍️",
                appellation: "Product Purchase",
                elucidation: "Compare products to buy",
                chromaGradient: (ChromaticPalette.primaryAzure, ChromaticPalette.secondaryViolet),
                criteria: ["Price", "Features", "Reviews"],
                sampleContenders: ["Option A", "Option B", "Option C"]
            ),
            RapidTemplate(
                iconGlyph: "✈️",
                appellation: "Travel Destination",
                elucidation: "Pick your next adventure",
                chromaGradient: (ChromaticPalette.tertiaryEmerald, ChromaticPalette.primaryAzure),
                criteria: ["Cost", "Activities", "Weather"],
                sampleContenders: ["Beach", "Mountains", "City"]
            ),
            RapidTemplate(
                iconGlyph: "🎲",
                appellation: "Random Choice",
                elucidation: "Let fate decide",
                chromaGradient: (ChromaticPalette.secondaryViolet, ChromaticPalette.accentCrimson),
                criteria: [],
                sampleContenders: []
            )
        ]

        for template in templates {
            let cardView = generateTemplateCard(template: template)
            contentStackView.addArrangedSubview(cardView)
        }
    }

    private func generateTemplateCard(template: RapidTemplate) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundCharcoal
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusAmplified
        containerView.translatesAutoresizingMaskIntoConstraints = false

        if template.appellation != "Random Choice" {
            DispatchQueue.main.async {
                containerView.applyGradientEmbellishment(
                    startingChroma: template.chromaGradient.0.withAlphaComponent(0.2),
                    terminatingChroma: template.chromaGradient.1.withAlphaComponent(0.2)
                )
            }
        }

        let iconLabel = UILabel()
        iconLabel.text = template.iconGlyph
        iconLabel.font = UIFont.systemFont(ofSize: 50)
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = template.appellation
        titleLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(20), weight: .bold)
        titleLabel.textColor = ChromaticPalette.foregroundIvory
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = template.elucidation
        descriptionLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .regular)
        descriptionLabel.textColor = ChromaticPalette.foregroundAsh
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let actionButton = UIButton(type: .system)
        if template.appellation == "Random Choice" {
            actionButton.setTitle("Spin", for: .normal)
        } else {
            actionButton.setTitle("Use Template", for: .normal)
        }
        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .semibold)
        actionButton.backgroundColor = template.chromaGradient.0
        actionButton.setTitleColor(ChromaticPalette.foregroundIvory, for: .normal)
        actionButton.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        actionButton.addAction(UIAction { [weak self] _ in
            self?.activateTemplate(template)
        }, for: .touchUpInside)

        containerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(actionButton)

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            titleLabel.centerYAnchor.constraint(equalTo: iconLabel.centerYAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            actionButton.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 20),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 48),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),

            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])

        containerView.applyShadowEmbellishment(opacity: 0.2, radius: 8)

        return containerView
    }

    private func activateTemplate(_ template: RapidTemplate) {
        if template.appellation == "Random Choice" {
            presentRandomChoiceDialog()
        } else {
            let deliberation = Deliberation(
                appellation: template.appellation,
                contenders: template.sampleContenders.map { Contender(appellation: $0) },
                criteria: template.criteria.map { Criterion(appellation: $0, preponderance: 1.0 / Double(template.criteria.count)) }
            )

            let creationController = DeliberationCompositionCoordinator()
            creationController.onCompletionClosure = { [weak self] finalDeliberation in
                self?.saveAndShowResults(deliberation: finalDeliberation)
            }
            let navController = UINavigationController(rootViewController: creationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }

    private func presentRandomChoiceDialog() {
        let alertController = UIAlertController(title: "Random Choice", message: "Enter your options (comma separated)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Pizza, Burger, Sushi"
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Choose", style: .default) { [weak self, weak alertController] _ in
            guard let input = alertController?.textFields?.first?.text else { return }
            let options = input.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }

            if !options.isEmpty {
                self?.showRandomResult(from: options)
            }
        })

        present(alertController, animated: true)
    }

    private func showRandomResult(from options: [String]) {
        guard let randomChoice = options.randomElement() else { return }

        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "🎲 Result",
            message: "The choice is:\n\n\(randomChoice)",
            actions: [
                DialogActionDescriptor(appellation: "OK", aestheticStyle: .primary, identificationTag: 0)
            ]
        )
        dialog.manifestInWindow()
    }

    private func saveAndShowResults(deliberation: Deliberation) {
        var savedDeliberations = (try? PersistenceCoordinator.quintessential.recuperateDeliberations()) ?? []
        savedDeliberations.insert(deliberation, at: 0)
        try? PersistenceCoordinator.quintessential.perpetuateDeliberations(savedDeliberations)

        let resultController = DeliberationVeracityViewController(deliberation: deliberation)
        navigationController?.pushViewController(resultController, animated: true)
    }
}

struct RapidTemplate {
    let iconGlyph: String
    let appellation: String
    let elucidation: String
    let chromaGradient: (UIColor, UIColor)
    let criteria: [String]
    let sampleContenders: [String]
}
