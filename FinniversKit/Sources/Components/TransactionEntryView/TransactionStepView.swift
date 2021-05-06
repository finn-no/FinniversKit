import Foundation

public class TransactionStepView: UIView {

    private lazy var processIllustrationView: UIView = {
        let view = TransactionStepIllustrationView(color: .btnPrimary)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 5
        return label
    }()

    private lazy var warningIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .warning)
        return imageView
    }()

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(processIllustrationView)
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(warningIconImageView)

        NSLayoutConstraint.activate([
            processIllustrationView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXS),
            processIllustrationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            processIllustrationView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: processIllustrationView.trailingAnchor, constant: .spacingS),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),

            warningIconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingS),
            warningIconImageView.topAnchor.constraint(equalTo: topAnchor),
            warningIconImageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: processIllustrationView.trailingAnchor, constant: .spacingS),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(withTitle title: String?, text: String?, showWarningIcon: Bool) {
        titleLabel.text = title
        textLabel.text = text
        warningIconImageView.isHidden = !showWarningIcon
    }
}
