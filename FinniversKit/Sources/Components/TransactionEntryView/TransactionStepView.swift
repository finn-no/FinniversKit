import UIKit

public class TransactionStepView: UIView {

    public enum SupplementaryView {
        case processIllustration
        case checkmark
    }

    // MARK: - Private properties

    private lazy var textLabel = Label(style: .detail, numberOfLines: 2, withAutoLayout: true)
    private lazy var checkmarkImageView = UIImageView(imageName: .checkmarkBlue, withAutoLayout: true)
    private lazy var warningIconImageView = UIImageView(imageName: .warning, withAutoLayout: true)
    private lazy var processIllustrationView = TransactionStepIllustrationView(color: .btnPrimary, withAutoLayout: true)
    private lazy var supplementaryStackView = UIStackView(axis: .vertical, spacing: 0, alignment: .top, withAutoLayout: true)
    private lazy var titleStackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, distribution: .equalSpacing, withAutoLayout: true)
    private lazy var supplementaryStackViewWidthConstraint = supplementaryStackView.widthAnchor.constraint(equalToConstant: 20)

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
        supplementaryStackView.addArrangedSubviews([processIllustrationView, checkmarkImageView, UIView(withAutoLayout: true)])
        processIllustrationView.isHidden = true
        checkmarkImageView.isHidden = true
        addSubview(supplementaryStackView)

        titleStackView.addArrangedSubviews([titleLabel, warningIconImageView])
        addSubview(titleStackView)

        addSubview(textLabel)

        NSLayoutConstraint.activate([
            supplementaryStackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXS),
            supplementaryStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            supplementaryStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            supplementaryStackViewWidthConstraint,

            checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),

            titleStackView.leadingAnchor.constraint(equalTo: supplementaryStackView.trailingAnchor, constant: .spacingS),
            titleStackView.topAnchor.constraint(equalTo: topAnchor),
            titleStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: supplementaryStackView.trailingAnchor, constant: .spacingS),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(
        withTitle title: String?,
        text: String?,
        supplementaryView: SupplementaryView = .processIllustration,
        showWarningIcon: Bool,
        numberOfTextLines: Int = 2
    ) {
        titleLabel.text = title
        textLabel.text = text
        textLabel.numberOfLines = numberOfTextLines
        warningIconImageView.isHidden = !showWarningIcon

        switch supplementaryView {
        case .processIllustration:
            processIllustrationView.isHidden = false
            checkmarkImageView.isHidden = true
            supplementaryStackViewWidthConstraint.constant = 12
        case .checkmark:
            checkmarkImageView.isHidden = false
            processIllustrationView.isHidden = true
            supplementaryStackViewWidthConstraint.constant = 20
        }
        layoutIfNeeded()
    }
}
