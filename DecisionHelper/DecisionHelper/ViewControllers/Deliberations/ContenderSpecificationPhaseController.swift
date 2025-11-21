import UIKit

class ContenderSpecificationPhaseController: UIViewController {
    private var contenderRepository: [Contender]
    private var onUpdateClosure: (([Contender]) -> Void)?

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Add 2-5 options to compare"
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

    private let addContenderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Add Option", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .semibold)
        button.backgroundColor = ChromaticPalette.backgroundSlate
        button.setTitleColor(ChromaticPalette.primaryAzure, for: .normal)
        button.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(existingContenders: [Contender], onUpdate: @escaping ([Contender]) -> Void) {
        self.contenderRepository = existingContenders
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
        tableView.register(ContenderInputCell.self, forCellReuseIdentifier: ContenderInputCell.reuseIdentifier)
    }

    private func configureLayout() {
        view.addSubview(instructionLabel)
        view.addSubview(tableView)
        view.addSubview(addContenderButton)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            tableView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addContenderButton.topAnchor, constant: -16),

            addContenderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            addContenderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            addContenderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            addContenderButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        addContenderButton.addTarget(self, action: #selector(appendNewContender), for: .touchUpInside)
    }

    @objc private func appendNewContender() {
        guard contenderRepository.count < 5 else {
            presentLimitationDialog()
            return
        }

        let newContender = Contender(appellation: "Option \(contenderRepository.count + 1)")
        contenderRepository.append(newContender)
        onUpdateClosure?(contenderRepository)
        tableView.reloadData()
    }

    private func presentLimitationDialog() {
        let dialog = EphemeralDialogPresenter()
        dialog.configurePresentationContent(
            title: "Maximum Reached",
            message: "You can add up to 5 options",
            actions: [
                DialogActionDescriptor(appellation: "OK", aestheticStyle: .primary, identificationTag: 0)
            ]
        )
        dialog.manifestInWindow()
    }
}

extension ContenderSpecificationPhaseController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contenderRepository.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContenderInputCell.reuseIdentifier, for: indexPath) as? ContenderInputCell else {
            return UITableViewCell()
        }

        let contender = contenderRepository[indexPath.row]
        cell.configureWithContender(contender, index: indexPath.row) { [weak self] updatedName in
            self?.contenderRepository[indexPath.row].appellation = updatedName
            self?.onUpdateClosure?(self?.contenderRepository ?? [])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return contenderRepository.count > 2
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            contenderRepository.remove(at: indexPath.row)
            onUpdateClosure?(contenderRepository)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

class ContenderInputCell: UITableViewCell {
    static let reuseIdentifier = "ContenderInputCell"

    private var onTextChangeClosure: ((String) -> Void)?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .bold)
        label.textColor = ChromaticPalette.primaryAzure
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .regular)
        textField.textColor = ChromaticPalette.foregroundIvory
        textField.placeholder = "Enter option name"
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
        containerView.addSubview(indexLabel)
        containerView.addSubview(inputTextField)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            containerView.heightAnchor.constraint(equalToConstant: 60),

            indexLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            indexLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            indexLabel.widthAnchor.constraint(equalToConstant: 30),

            inputTextField.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 12),
            inputTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        inputTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func configureWithContender(_ contender: Contender, index: Int, onTextChange: @escaping (String) -> Void) {
        indexLabel.text = "\(index + 1)."
        inputTextField.text = contender.appellation
        onTextChangeClosure = onTextChange
    }

    @objc private func textFieldDidChange() {
        onTextChangeClosure?(inputTextField.text ?? "")
    }
}
