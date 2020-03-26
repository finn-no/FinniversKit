//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol TransactionProcessSummaryViewDelegate: AnyObject {
    func transactionProcessSummaryViewWasTapped(_ view: TransactionProcessSummaryView)
}

public class TransactionProcessSummaryView: UIView {
    public weak var delegate: TransactionProcessSummaryViewDelegate?

    // MARK: - Private properties

    private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
    private var iconSize: CGFloat = .spacingL
    private var chevronSize: CGFloat = .spacingM

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .handshake).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .licorice
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .stone
        return label
    }()

    private lazy var chevronView: UIImageView = {
        let chevron = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        var imageView = UIImageView(image: chevron)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .stone
        return imageView
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private let contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    public func configure(with viewModel: TransactionProcessSummaryViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        descriptionLabel.text = viewModel.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TransactionProcessSummaryView {
    func setup() {
        contentView.addGestureRecognizer(tapRecognizer)

        backgroundColor = .bgPrimary
        contentView.backgroundColor = .bgPrimary

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(descriptionLabel)

        addSubview(contentView)
        contentView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize),

            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor),

            detailLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -.spacingS),

            chevronView.centerYAnchor.constraint(equalTo: detailLabel.centerYAnchor),
            chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXS),
            chevronView.widthAnchor.constraint(equalToConstant: chevronSize),
            chevronView.heightAnchor.constraint(equalToConstant: chevronSize),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -.spacingM),

            contentView.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: -.spacingM),
            contentView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: .spacingM),

            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func onTap() {
        delegate?.transactionProcessSummaryViewWasTapped(self)
    }
}
