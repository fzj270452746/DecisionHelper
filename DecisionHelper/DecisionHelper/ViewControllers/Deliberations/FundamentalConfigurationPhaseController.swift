import UIKit

class FundamentalConfigurationPhaseController: UIViewController {
    private var onUpdateClosure: ((String) -> Void)?
    private var existingTitle: String

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Let's start by naming your decision"
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(17), weight: .medium)
        textField.textColor = ChromaticPalette.foregroundIvory
        textField.backgroundColor = ChromaticPalette.backgroundSlate
        textField.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        textField.layer.borderWidth = 2
        textField.layer.borderColor = ChromaticPalette.primaryAzure.withAlphaComponent(0.4).cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false

        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: ChromaticPalette.foregroundAsh,
            .font: UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(17), weight: .regular)
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "e.g., Choose a new laptop",
            attributes: placeholderAttributes
        )

        return textField
    }()

    private let illustrationLabel: UILabel = {
        let label = UILabel()
        label.text = "💭"
        label.font = UIFont.systemFont(ofSize: 80)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(existingTitle: String, onUpdate: @escaping (String) -> Void) {
        self.existingTitle = existingTitle
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
        titleTextField.text = existingTitle
        titleTextField.delegate = self
    }

    private func configureAppearance() {
        view.backgroundColor = ChromaticPalette.backgroundObsidian
    }

    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(illustrationLabel)
        contentView.addSubview(instructionLabel)
        contentView.addSubview(titleTextField)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            illustrationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            illustrationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            instructionLabel.topAnchor.constraint(equalTo: illustrationLabel.bottomAnchor, constant: 32),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),

            titleTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            titleTextField.heightAnchor.constraint(equalToConstant: 54),
            titleTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

extension FundamentalConfigurationPhaseController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        onUpdateClosure?(textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
