//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionEntryAdManagementViewDelegate: AnyObject {
    func motorTransactionEntryViewWasTapped(_ view: MotorTransactionEntryAdManagementView)
    func motorTransactionEntryExternalViewWasTapped(_ view: MotorTransactionEntryAdManagementView)
}

public class MotorTransactionEntryAdManagementView: UIView {
    public weak var delegate: MotorTransactionEntryAdManagementViewDelegate?

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

    private lazy var contentViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
    private lazy var externalContentViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapExternalContentView))

    private var iconSize: CGFloat = .spacingL
    private var chevronSize: CGFloat = .spacingM

    private var viewBottomAnchor: NSLayoutYAxisAnchor?

    // MARK: - contentView properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .handshake).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textSecondary
        return label
    }()

    private lazy var chevronView: UIImageView = {
        let chevron = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        var imageView = UIImageView(image: chevron)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .textSecondary
        return imageView
    }()

    private lazy var errorImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .exclamationMarkTriangleMini)
        return imageView
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private let contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        return view
    }()

    // MARK: - externalContentView properties

    private lazy var externalTitleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textPrimary
        return label
    }()

    private lazy var externalImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconSecondary
        return imageView
    }()

    private let externalContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
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

    // MARK: - Public

    public func configure(with viewModel: MotorTransactionEntryViewModel, shouldShowExternalView showExternal: Bool) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        descriptionLabel.text = viewModel.description

        if let style = viewModel.style {
            setupStyle(with: .init(rawValue: style))
        }

        if showExternal {
            setupExternalContentView()
            externalTitleLabel.text = viewModel.externalView?.text
            viewBottomAnchor = externalContentView.bottomAnchor
        } else {
            externalContentView.removeFromSuperview()
            viewBottomAnchor = contentView.bottomAnchor
        }

        bottomAnchor.constraint(equalTo: viewBottomAnchor!).isActive = true
    }
}

// MARK: - Private

private extension MotorTransactionEntryAdManagementView {
    func setup() {
        backgroundColor = .bgPrimary
        setupContentView()
    }

    private func setupContentView() {
        addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronView)
        contentView.addSubview(descriptionLabel)

        contentView.addGestureRecognizer(contentViewTapRecognizer)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
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

            topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }

    private func setupExternalContentView() {
        addSubview(externalContentView)

        externalContentView.addSubview(separatorView)
        externalContentView.addSubview(externalTitleLabel)
        externalContentView.addSubview(externalImageView)

        externalContentView.addGestureRecognizer(externalContentViewTapRecognizer)

        NSLayoutConstraint.activate([
            externalContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            externalContentView.trailingAnchor.constraint(equalTo: trailingAnchor),

            separatorView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            separatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: externalContentView.trailingAnchor),

            externalTitleLabel.topAnchor.constraint(equalTo: separatorView.topAnchor, constant: .spacingM),
            externalTitleLabel.leadingAnchor.constraint(equalTo: separatorView.leadingAnchor),

            externalImageView.centerYAnchor.constraint(equalTo: externalTitleLabel.centerYAnchor),
            externalImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingL),

            externalContentView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            externalContentView.bottomAnchor.constraint(equalTo: externalTitleLabel.bottomAnchor, constant: .spacingM)
        ])
    }

    private func setupStyle(with style: Style) {
        switch style {
        case .error:
            contentView.addSubview(errorImageView)
            NSLayoutConstraint.activate([
                errorImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                errorImageView.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: -.spacingS)
            ])
        case .default: return
        }
    }

    @objc private func didTapContentView() {
        delegate?.motorTransactionEntryViewWasTapped(self)
    }

    @objc private func didTapExternalContentView() {
        delegate?.motorTransactionEntryExternalViewWasTapped(self)
    }
}
