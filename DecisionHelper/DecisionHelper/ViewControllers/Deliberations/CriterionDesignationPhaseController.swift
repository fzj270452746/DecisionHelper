import UIKit

class CriterionDesignationPhaseController: UIViewController {
    private var criteriaRepository: [Criterion]
    private var onUpdateClosure: (([Criterion]) -> Void)?

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Define criteria for comparison"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
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

    private let addCriterionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Criterion", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .semibold)
        button.backgroundColor = ChromaticPalette.backgroundSlate
        button.setTitleColor(ChromaticPalette.secondaryViolet, for: .normal)
        button.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(existingCriteria: [Criterion], onUpdate: @escaping ([Criterion]) -> Void) {
        self.criteriaRepository = existingCriteria
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
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CriterionInputCell.self, forCellReuseIdentifier: CriterionInputCell.reuseIdentifier)
    }

    private func configureLayout() {
        view.addSubview(instructionLabel)
        view.addSubview(tableView)
        view.addSubview(addCriterionButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            tableView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCriterionButton.topAnchor, constant: -16),

            addCriterionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            addCriterionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            addCriterionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addCriterionButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        addCriterionButton.addTarget(self, action: #selector(appendNewCriterion), for: .touchUpInside)
    }

    @objc private func appendNewCriterion() {
        let newCriterion = Criterion(appellation: "Criterion \(criteriaRepository.count + 1)", preponderance: 1.0)
        criteriaRepository.append(newCriterion)
        onUpdateClosure?(criteriaRepository)
        tableView.reloadData()
    }
}

extension CriterionDesignationPhaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return criteriaRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CriterionInputCell.reuseIdentifier, for: indexPath) as? CriterionInputCell else {
            return UITableViewCell()
        }

        let criterion = criteriaRepository[indexPath.row]
        cell.configureWithCriterion(criterion) { [weak self] updatedName in
            self?.criteriaRepository[indexPath.row].appellation = updatedName
            self?.onUpdateClosure?(self?.criteriaRepository ?? [])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return criteriaRepository.count > 1
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            criteriaRepository.remove(at: indexPath.row)
            onUpdateClosure?(criteriaRepository)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

class CriterionInputCell: UITableViewCell {
    static let reuseIdentifier = "CriterionInputCell"

    private var onTextChangeClosure: ((String) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let iconLabel: UILabel = {
        let label = UILabel()
        label.text = "◆"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = ChromaticPalette.secondaryViolet
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .regular)
        textField.textColor = ChromaticPalette.foregroundIvory
        textField.placeholder = "Enter criterion name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        containerView.addSubview(iconLabel)
        containerView.addSubview(inputTextField)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.heightAnchor.constraint(equalToConstant: 60),

            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 24),

            inputTextField.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func configureWithCriterion(_ criterion: Criterion, onTextChange: @escaping (String) -> Void) {
        inputTextField.text = criterion.appellation
        onTextChangeClosure = onTextChange
    }

    @objc private func textFieldDidChange() {
        onTextChangeClosure?(inputTextField.text ?? "")
    }
}
