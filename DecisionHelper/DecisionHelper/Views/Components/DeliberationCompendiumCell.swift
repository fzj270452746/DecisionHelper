import UIKit

class DeliberationCompendiumCell: UITableViewCell {
    static let reuseIdentifier = "DeliberationCompendiumCell"

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.backgroundCharcoal
        view.layer.cornerRadius = DimensionalAdaptation.cornerRadiusStandard
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(18), weight: .semibold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let contenderSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(13), weight: .regular)
        label.textColor = ChromaticPalette.foregroundAsh
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sovereignBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(14), weight: .bold)
        label.textColor = ChromaticPalette.foregroundIvory
        label.backgroundColor = ChromaticPalette.primaryAzure
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: DimensionalAdaptation.calibratedTypography(12), weight: .regular)
        label.textColor = ChromaticPalette.foregroundAsh
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let accentStripe: UIView = {
        let view = UIView()
        view.backgroundColor = ChromaticPalette.secondaryViolet
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        containerView.addSubview(accentStripe)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contenderSummaryLabel)
        containerView.addSubview(sovereignBadgeLabel)
        containerView.addSubview(timestampLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DimensionalAdaptation.horizontalMargin),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DimensionalAdaptation.horizontalMargin),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            accentStripe.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            accentStripe.topAnchor.constraint(equalTo: containerView.topAnchor),
            accentStripe.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            accentStripe.widthAnchor.constraint(equalToConstant: 4),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: accentStripe.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            contenderSummaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contenderSummaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contenderSummaryLabel.trailingAnchor.constraint(equalTo: sovereignBadgeLabel.leadingAnchor, constant: -8),

            sovereignBadgeLabel.centerYAnchor.constraint(equalTo: contenderSummaryLabel.centerYAnchor),
            sovereignBadgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            sovereignBadgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            sovereignBadgeLabel.heightAnchor.constraint(equalToConstant: 24),

            timestampLabel.topAnchor.constraint(equalTo: contenderSummaryLabel.bottomAnchor, constant: 8),
            timestampLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            timestampLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])

        containerView.applyShadowEmbellishment(opacity: 0.2, radius: 6)
    }

    func configureWithDeliberation(_ deliberation: Deliberation) {
        titleLabel.text = deliberation.appellation

        let contenderQuantity = deliberation.contenders.count
        contenderSummaryLabel.text = "\(contenderQuantity) options"

        if let sovereign = deliberation.sovereignContender() {
            sovereignBadgeLabel.text = "★ \(sovereign.appellation)"
            sovereignBadgeLabel.isHidden = false
        } else {
            sovereignBadgeLabel.isHidden = true
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        timestampLabel.text = formatter.localizedString(for: deliberation.lastModificationTimestamp, relativeTo: Date())
    }
}
