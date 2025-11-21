import UIKit

class PersonalArchiveViewController: UIViewController {
    private var deliberationRepository: [Deliberation] = []

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = ChromaticPalette.backgroundObsidian
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emptyIconLabel: UILabel = {
        let label = UILabel()
        label.text = "📦"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let emptyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "No archived decisions\nCreate one to get started"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .regular)
        label.textColor = ChromaticPalette.foregroundAsh
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let statisticsHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTableView()
        configureEmptyState()
        configureStatisticsHeader()
        configureLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recuperateDeliberations()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
        title = "Archive"

        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(presentSettings)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DeliberationCompendiumCell.self, forCellReuseIdentifier: DeliberationCompendiumCell.reuseIdentifier)
    }

    private func configureEmptyState() {
        emptyStateView.addSubview(emptyIconLabel)
        emptyStateView.addSubview(emptyTextLabel)

        NSLayoutConstraint.activate([
            emptyIconLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIconLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -30),

            emptyTextLabel.topAnchor.constraint(equalTo: emptyIconLabel.bottomAnchor, constant: 20),
            emptyTextLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: emptyStateView.leadingAnchor, constant: 40),
            emptyTextLabel.trailingAnchor.constraint(lessThanOrEqualTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }

    private func configureStatisticsHeader() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false

        statisticsHeaderView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: statisticsHeaderView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: statisticsHeaderView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            stackView.trailingAnchor.constraint(equalTo: statisticsHeaderView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            stackView.bottomAnchor.constraint(equalTo: statisticsHeaderView.bottomAnchor, constant: -16)
        ])

        let totalCard = generateStatisticCard(iconGlyph: "📊", valueText: "0", labelText: "Total")
        let thisWeekCard = generateStatisticCard(iconGlyph: "📅", valueText: "0", labelText: "This Week")
        let avgScoreCard = generateStatisticCard(iconGlyph: "⭐", valueText: "0", labelText: "Avg Score")

        stackView.addArrangedSubview(totalCard)
        stackView.addArrangedSubview(thisWeekCard)
        stackView.addArrangedSubview(avgScoreCard)
    }

    private func generateStatisticCard(iconGlyph: String, valueText: String, labelText: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = ChromaticPalette.backgroundSlate
        containerView.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let iconLabel = UILabel()
        iconLabel.text = iconGlyph
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        let valueLabel = UILabel()
        valueLabel.text = valueText
        valueLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(22), weight: .bold)
        valueLabel.textColor = ChromaticPalette.foregroundIvory
        valueLabel.textAlignment = .center
        valueLabel.tag = 100
        valueLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = labelText
        descriptionLabel.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(11), weight: .regular)
        descriptionLabel.textColor = ChromaticPalette.foregroundAsh
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(iconLabel)
        containerView.addSubview(valueLabel)
        containerView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            iconLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            valueLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 8),
            valueLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            descriptionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),

            containerView.heightAnchor.constraint(equalToConstant: 110)
        ])

        return containerView
    }

    private func configureLayout() {
        view.addSubview(statisticsHeaderView)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)

        NSLayoutConstraint.activate([
            statisticsHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statisticsHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statisticsHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: statisticsHeaderView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateView.topAnchor.constraint(equalTo: statisticsHeaderView.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func recuperateDeliberations() {
        do {
            deliberationRepository = try PersistenceCoordinator.quintessential.recuperateDeliberations()
            deliberationRepository.sort { $0.lastModificationTimestamp > $1.lastModificationTimestamp }
            updateStatistics()
            updateEmptyState()
            tableView.reloadData()
        } catch {
            presentErrorDialog(message: "Failed to load archive")
        }
    }

    private func updateStatistics() {
        guard let stackView = statisticsHeaderView.subviews.first as? UIStackView else { return }

        if let totalCard = stackView.arrangedSubviews[0].viewWithTag(100) as? UILabel {
            totalCard.text = "\(deliberationRepository.count)"
        }

        let calendar = Calendar.current
        let now = Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
        let thisWeekCount = deliberationRepository.filter { $0.chronicleTimestamp >= weekAgo }.count

        if let weekCard = stackView.arrangedSubviews[1].viewWithTag(100) as? UILabel {
            weekCard.text = "\(thisWeekCount)"
        }

        let avgScore = calculateAverageScore()
        if let scoreCard = stackView.arrangedSubviews[2].viewWithTag(100) as? UILabel {
            scoreCard.text = String(format: "%.0f", avgScore)
        }
    }

    private func calculateAverageScore() -> Double {
        guard !deliberationRepository.isEmpty else { return 0 }

        var totalScore: Double = 0
        var validCount = 0

        for deliberation in deliberationRepository {
            if let sovereign = deliberation.sovereignContender() {
                let score = sovereign.calculateAggregatedValuation(with: deliberation.reconciledCriteria())
                totalScore += score
                validCount += 1
            }
        }

        return validCount > 0 ? totalScore / Double(validCount) : 0
    }

    private func updateEmptyState() {
        let isEmpty = deliberationRepository.isEmpty
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    @objc private func presentSettings() {
        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "Settings",
            message: "Clear all archive data?",
            actions: [
                DialogActionDescriptor(appellation: "Cancel", aestheticStyle: .secondary, identificationTag: 0),
                DialogActionDescriptor(appellation: "Clear All", aestheticStyle: .destructive, identificationTag: 1)
            ]
        )
        dialog.manifestInWindow { [weak self] in
            self?.clearAllData()
        }
    }

    private func clearAllData() {
        do {
            try PersistenceCoordinator.quintessential.obliterateAllDeliberations()
            recuperateDeliberations()
        } catch {
            presentErrorDialog(message: "Failed to clear data")
        }
    }

    private func presentErrorDialog(message: String) {
        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "Error",
            message: message,
            actions: [
                DialogActionDescriptor(appellation: "OK", aestheticStyle: .primary, identificationTag: 0)
            ]
        )
        dialog.manifestInWindow()
    }
}

extension PersonalArchiveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliberationRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DeliberationCompendiumCell.reuseIdentifier, for: indexPath) as? DeliberationCompendiumCell else {
            return UITableViewCell()
        }

        let deliberation = deliberationRepository[indexPath.row]
        cell.configureWithDeliberation(deliberation)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deliberation = deliberationRepository[indexPath.row]
        let resultController = DeliberationVeracityViewController(deliberation: deliberation)
        navigationController?.pushViewController(resultController, animated: true)
    }
}
