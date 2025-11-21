import UIKit

class EphemeralDialogPresenter: UIView {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusAmplified
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(22), weight: .bold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(15), weight: .regular)
        label.textColor = ChromaticPalette.foregroundPearl
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private var onDismissalClosure: (() -> Void)?

    init() {
        super.init(frame: .zero)
        configureHierarchy()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        backgroundColor = ChromaticPalette.overlayMidnight

        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),

            buttonStackView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 28),
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])

        containerView.applyShadowEmbellishment(opacity: 0.5, radius: 20)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapRecognized))
        addGestureRecognizer(tapGesture)
    }

    func configurePresentationContent(title: String, message: String, actions: [DialogActionDescriptor]) {
        titleLabel.text = title
        messageLabel.text = message

        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for actionDescriptor in actions {
            let button = generateActionButton(for: actionDescriptor)
            buttonStackView.addArrangedSubview(button)
        }
    }

    private func generateActionButton(for descriptor: DialogActionDescriptor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(descriptor.appellation, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(16), weight: .semibold)
        button.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard

        switch descriptor.aestheticStyle {
        case .primary:
            button.backgroundColor = ChromaticPalette.primaryAzure
            button.setTitleColor(ChromaticPalette.foregroundIvory, for: .normal)
        case .destructive:
            button.backgroundColor = ChromaticPalette.accentCrimson
            button.setTitleColor(ChromaticPalette.foregroundIvory, for: .normal)
        case .secondary:
            button.backgroundColor = ChromaticPalette.backgroundSlate
            button.setTitleColor(ChromaticPalette.foregroundPearl, for: .normal)
        }

        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        button.tag = descriptor.identificationTag
        return button
    }

    @objc private func actionButtonTapped(_ sender: UIButton) {
        dismissWithAnimation {
            self.onDismissalClosure?()
        }
    }

    @objc private func backgroundTapRecognized() {
        dismissWithAnimation()
    }

    func manifestInWindow(completion: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        onDismissalClosure = completion

        frame = window.bounds
        alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        window.addSubview(self)

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = 1.0
            self.containerView.transform = .identity
        })
    }

    func dismissWithAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}

struct DialogActionDescriptor {
    enum AestheticStyle {
        case primary
        case destructive
        case secondary
    }

    let appellation: String
    let aestheticStyle: AestheticStyle
    let identificationTag: Int
}
