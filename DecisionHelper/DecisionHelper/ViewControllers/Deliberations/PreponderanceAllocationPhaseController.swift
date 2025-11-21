import UIKit

class PreponderanceAllocationPhaseController: UIViewController {
    private var criteriaRepository: [Criterion]
    private var onUpdateClosure: (([Criterion]) -> Void)?

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Set importance for each criterion"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let normalizationToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true
        toggle.onTintColor = ChromaticPalette.primaryAzure
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let normalizationLabel: UILabel = {
        let label = UILabel()
        label.text = "Auto-normalize weights"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .regular)
        label.textColor = ChromaticPalette.foregroundPearl
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = ChromaticPalette.backgroundObsidian
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    init(criteria: [Criterion], onUpdate: @escaping ([Criterion]) -> Void) {
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
        configureTableView()
        configureLayout()
        equalizeWeights()
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PreponderanceSliderCell.self, forCellReuseIdentifier: PreponderanceSliderCell.reuseIdentifier)
    }

    private func configureLayout() {
        view.addSubview(instructionLabel)
        view.addSubview(normalizationToggle)
        view.addSubview(normalizationLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            normalizationLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            normalizationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),

            normalizationToggle.centerYAnchor.constraint(equalTo: normalizationLabel.centerYAnchor),
            normalizationToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            tableView.topAnchor.constraint(equalTo: normalizationLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        normalizationToggle.addTarget(self, action: #selector(normalizationToggled), for: .valueChanged)
    }

    private func equalizeWeights() {
        let equalWeight = 1.0 / Double(criteriaRepository.count)
        for index in criteriaRepository.indices {
            criteriaRepository[index].preponderance = equalWeight
        }
        onUpdateClosure?(criteriaRepository)
    }

    @objc private func normalizationToggled() {
        if normalizationToggle.isOn {
            normalizeWeights()
        }
    }

    private func normalizeWeights() {
        let totalWeight = criteriaRepository.reduce(0.0) { $0 + $1.preponderance }
        guard totalWeight > 0 else { return }

        for index in criteriaRepository.indices {
            criteriaRepository[index].preponderance /= totalWeight
        }
        onUpdateClosure?(criteriaRepository)
        tableView.reloadData()
    }

    private func updateWeight(at index: Int, newValue: Double) {
        criteriaRepository[index].preponderance = newValue

        if normalizationToggle.isOn {
            normalizeWeights()
        } else {
            onUpdateClosure?(criteriaRepository)
        }
    }
}

extension PreponderanceAllocationPhaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criteriaRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreponderanceSliderCell.reuseIdentifier, for: indexPath) as? PreponderanceSliderCell else {
            return UITableViewCell()
        }

        let criterion = criteriaRepository[indexPath.row]
        cell.configureWithCriterion(criterion) { [weak self] newValue in
            self?.updateWeight(at: indexPath.row, newValue: newValue)
        }
        return cell
    }
}

class PreponderanceSliderCell: UITableViewCell {
    static let reuseIdentifier = "PreponderanceSliderCell"

    private var onValueChangeClosure: ((Double) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .bold)
        label.textColor = ChromaticPalette.primaryAzure
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let preponderanceSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.minimumTrackTintColor = ChromaticPalette.primaryAzure
        slider.maximumTrackTintColor = ChromaticPalette.separatorGraphite
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(percentageLabel)
        containerView.addSubview(preponderanceSlider)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),

            percentageLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            percentageLabel.widthAnchor.constraint(equalToConstant: 60),

            preponderanceSlider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            preponderanceSlider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            preponderanceSlider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            preponderanceSlider.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        preponderanceSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }

    func configureWithCriterion(_ criterion: Criterion, onValueChange: @escaping (Double) -> Void) {
        titleLabel.text = criterion.appellation
        preponderanceSlider.value = Float(criterion.preponderance)
        percentageLabel.text = String(format: "%.0f%%", criterion.preponderance * 100)
        onValueChangeClosure = onValueChange
    }

    @objc private func sliderValueChanged() {
        let newValue = Double(preponderanceSlider.value)
        percentageLabel.text = String(format: "%.0f%%", newValue * 100)
        onValueChangeClosure?(newValue)
    }
}
