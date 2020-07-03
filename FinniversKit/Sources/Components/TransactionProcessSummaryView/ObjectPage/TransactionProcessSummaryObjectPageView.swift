//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol TransactionProcessSummaryObjectPageViewDelegate: AnyObject {
    func transactionProcessSummaryObjectPageViewButtonWasTapped(_ view: TransactionProcessSummaryObjectPageView)
}

public class TransactionProcessSummaryObjectPageView: UIView {
    public weak var delegate: TransactionProcessSummaryObjectPageViewDelegate?

    // MARK: - Private properties

    private enum Style: String {
        case `default`
        case error = "ERROR"

        init(rawValue: String) {
            switch rawValue {
            case "ERROR":
                self = .error
            default:
                self = .default
            }
        }
    }

    private lazy var handshakeImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .handshake).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: Button = {
        let arrowRightImage = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        button.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
        button.setImage(arrowRightImage, for: .normal)
        button.imageView?.tintColor = .iconTertiary
        button.imageEdgeInsets = UIEdgeInsets(
            top: button.imageEdgeInsets.top,
            leading: button.imageEdgeInsets.leading - .spacingL - .spacingM,
            bottom: button.imageEdgeInsets.bottom,
            trailing: -.spacingM
        )
        return button
    }()

    private let contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgSecondary
        view.layer.cornerRadius = .spacingS
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    public func configure(with viewModel: TransactionProcessSummaryViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        actionButton.setTitle(viewModel.detail, for: .normal)

        if let style = viewModel.style {
            setupStyle(with: .init(rawValue: style))
        }
    }
}

// MARK: - Private methods

extension TransactionProcessSummaryObjectPageView {
    private func setup() {
        backgroundColor = .clear

        contentView.addSubview(handshakeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(actionButton)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            handshakeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            handshakeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            handshakeImageView.widthAnchor.constraint(equalToConstant: .spacingL),
            handshakeImageView.heightAnchor.constraint(equalToConstant: .spacingL),

            titleLabel.leadingAnchor.constraint(equalTo: handshakeImageView.trailingAnchor, constant: .spacingS),
            titleLabel.topAnchor.constraint(equalTo: handshakeImageView.topAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: handshakeImageView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXXL),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),

            actionButton.leadingAnchor.constraint(equalTo: handshakeImageView.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingL),
            actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingM),

            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .spacingL),

            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupStyle(with style: Style) {
        switch style {
        case .error:
            let imageView = UIImageView(withAutoLayout: true)
            imageView.image = UIImage(named: .exclamationMarkTriangleMini)
            contentView.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
                imageView.widthAnchor.constraint(equalToConstant: .spacingM),
                imageView.heightAnchor.constraint(equalToConstant: .spacingM)
            ])

        case .default: return
        }
    }

    @objc private func didTapActionButton(_ sender: Button) {
        delegate?.transactionProcessSummaryObjectPageViewButtonWasTapped(self)
    }
}
