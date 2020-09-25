import FinniversKit

public protocol ObjectPageBlinkViewDelegate: AnyObject {
    func objectPageBlinkViewDidSelectReadMoreButton(view: ObjectPageBlinkView)
}

public class ObjectPageBlinkView: UIView {

    // MARK: - Public properties

    public weak var delegate: ObjectPageBlinkViewDelegate?

    // MARK: - Private properties

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
        stackView.addArrangedSubviews([iconTitleStackView, increasedClickLabel, readMoreButtonStackView])
        stackView.setCustomSpacing(.spacingS, after: iconTitleStackView)
        return stackView
    }()

    private lazy var readMoreButtonStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, withAutoLayout: true)
        stackView.addArrangedSubviews([readMoreButton, UIView()])
        return stackView
    }()

    private lazy var iconTitleStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([iconImageView, titleLabel])
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .blinkRocket)
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var increasedClickLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var readMoreButton: Button = {
        let button = Button(style: .link, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleReadMoreButtonTap), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        contentStackView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            iconImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ObjectPageBlinkViewModel) {
        titleLabel.text = viewModel.title

        if let increasedClickPercentage = viewModel.increasedClickPercentage {
            increasedClickLabel.isHidden = false
            let percentageAttributedString = "+\(increasedClickPercentage)% ".asAttributedString(attributes: [.font: UIFont.bodyStrong])
            let increasedClickLabelAttributedString = NSMutableAttributedString(attributedString: percentageAttributedString)
            increasedClickLabelAttributedString.append(viewModel.increasedClickDescription.asAttributedString())
            increasedClickLabel.attributedText = increasedClickLabelAttributedString
        } else {
            increasedClickLabel.isHidden = true
        }

        readMoreButton.setTitle(viewModel.readMoreButtonTitle, for: .normal)
    }

    // MARK: - Actions

    @objc private func handleReadMoreButtonTap() {
        delegate?.objectPageBlinkViewDidSelectReadMoreButton(view: self)
    }
}
