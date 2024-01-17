import UIKit

public class TransactionStepView: UIView {

    public enum SupplementaryViewKind {
        case processIllustration
        case checkmark
    }

    // MARK: - Private properties

    private lazy var textLabel = Label(style: .detail, numberOfLines: 2, withAutoLayout: true)
    private lazy var warningIconImageView = UIImageView(imageName: .warning, withAutoLayout: true)
    private lazy var supplementaryView = SupplementaryView(withAutoLayout: true)
    private lazy var titleStackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .top, distribution: .equalSpacing, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong, numberOfLines: 0, withAutoLayout: true)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        titleStackView.addArrangedSubviews([titleLabel, warningIconImageView])
        addSubview(titleStackView)
        addSubview(supplementaryView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            supplementaryView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXS),
            supplementaryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            supplementaryView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleStackView.leadingAnchor.constraint(equalTo: supplementaryView.trailingAnchor, constant: .spacingS),
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: supplementaryView.trailingAnchor, constant: .spacingS),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(
        withTitle title: String?,
        text: String?,
        supplementaryViewKind: SupplementaryViewKind = .processIllustration,
        showWarningIcon: Bool,
        numberOfTextLines: Int = 2
    ) {
        titleLabel.text = title
        textLabel.text = text
        textLabel.numberOfLines = numberOfTextLines
        warningIconImageView.isHidden = !showWarningIcon
        supplementaryView.configure(with: supplementaryViewKind)
        layoutIfNeeded()
    }
}

// MARK: - Private subtypes

private extension TransactionStepView {
    class SupplementaryView: UIView {

        // MARK: - Private properties

        private lazy var checkmarkImageView = UIImageView(image: .brandCheckmark, withAutoLayout: true)
        private lazy var processIllustrationView = TransactionStepIllustrationView(color: .nmpBrandDecoration, withAutoLayout: true)

        // MARK: - Internal methods

        func configure(with kind: SupplementaryViewKind) {
            subviews.forEach { $0.removeFromSuperview() }
            switch kind {
            case .processIllustration:
                addSubview(processIllustrationView)
                processIllustrationView.fillInSuperview()
            case .checkmark:
                addSubview(checkmarkImageView)
                NSLayoutConstraint.activate([
                    checkmarkImageView.topAnchor.constraint(equalTo: topAnchor),
                    checkmarkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
                    checkmarkImageView.heightAnchor.constraint(equalTo: checkmarkImageView.widthAnchor),
                ])
            }
        }
    }
}
