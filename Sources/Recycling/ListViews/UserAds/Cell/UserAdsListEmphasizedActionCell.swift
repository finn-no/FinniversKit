//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Delegate to handle interaction happening inside the cell
public protocol UserAdsListEmphasizedActionCellDelegate: class {
    func userAdsListEmphasizedActionCell(_ cell: UserAdsListEmphasizedActionCell, buttonWasTapped: Button)
    func userAdsListEmphasizedActionCell(_ cell: UserAdsListEmphasizedActionCell, cancelButtonWasTapped: Button)
}

public class UserAdsListEmphasizedActionCell: UITableViewCell {
    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.

    public var loadingColor: UIColor?

    /// A data source for the loading of the image

    public weak var dataSource: UserAdsListViewCellDataSource?

    public weak var delegate: UserAdsListEmphasizedActionCellDelegate?

    /// Informs the cell whether it should display the available action or not
    public var shouldShowAction = true

    // MARK: - Internal properties

    private static let cornerRadius: CGFloat = 12
    private static let imageSize: CGFloat = 104
    private let defaultImage = UIImage(named: .noImage)

    private lazy var userAdStatus: UserAdStatus = .unknown

    private lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = UserAdsListEmphasizedActionCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }()

    private lazy var priceLabel: Label? = {
        let label = Label(style: .detailStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .stone
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var ribbonView: RibbonView? = nil

    private lazy var adWrapperView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .milk
        view.layer.cornerRadius = UserAdsListEmphasizedActionCell.cornerRadius
        return view
    }()

    private lazy var actionWrapper: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()

    private lazy var actionTitleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actionDescriptionLabel: Label = {
        let label = Label(style: .caption)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var cancelButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var gradientWrapper: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .marble
        return view
    }()

    private lazy var gradientLayer: CALayer = {
        let layer = CAGradientLayer()
        let color = UIColor.white.withAlphaComponent(0.75)
        layer.colors = [UIColor.marble.cgColor, color.cgColor]
        layer.locations = [0.1, 1.0]
        return layer
    }()

    private var actionWrapperHideConstraint = NSLayoutConstraint()
    private var actionWrapperHeightConstraint = NSLayoutConstraint()

    // MARK: - Setup

    private func setupView() {
        isAccessibilityElement = true
        contentView.backgroundColor = .marble
        accessoryType = .none
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: (UserAdsListEmphasizedActionCell.imageSize + .mediumSpacing), bottom: 0, right: 0)

        contentView.addSubview(adWrapperView)
        adWrapperView.addSubview(adImageView)
        adWrapperView.addSubview(titleLabel)
        adWrapperView.addSubview(detailLabel)

        contentView.addSubview(actionWrapper)
        actionWrapper.addSubview(actionTitleLabel)
        actionWrapper.addSubview(actionDescriptionLabel)
        actionWrapper.addSubview(actionButton)

        actionWrapper.addSubview(gradientWrapper)
        gradientWrapper.layer.addSublayer(gradientLayer)

        actionWrapperHideConstraint = NSLayoutConstraint(item: actionWrapper, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        actionWrapperHeightConstraint = NSLayoutConstraint(item: actionWrapper, attribute: .bottomMargin, relatedBy: .equal, toItem: actionButton, attribute: .bottomMargin, multiplier: 1, constant: .largeSpacing)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: actionWrapper.bottomAnchor),

            adWrapperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            adWrapperView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            adWrapperView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -.largeSpacing),
            adWrapperView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),

            adImageView.heightAnchor.constraint(equalToConstant: UserAdsListEmphasizedActionCell.imageSize),
            adImageView.widthAnchor.constraint(equalToConstant: UserAdsListEmphasizedActionCell.imageSize),
            adImageView.topAnchor.constraint(equalTo: adWrapperView.topAnchor, constant: .mediumSpacing),
            adImageView.leadingAnchor.constraint(equalTo: adWrapperView.leadingAnchor, constant: .mediumSpacing),

            titleLabel.topAnchor.constraint(equalTo: adImageView.topAnchor, constant: -.mediumSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: (ribbonView?.topAnchor ?? detailLabel.topAnchor), constant: -.smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: adWrapperView.trailingAnchor),

            detailLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),

            actionWrapper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            actionWrapper.topAnchor.constraint(equalTo: adWrapperView.bottomAnchor, constant: .mediumLargeSpacing),
            actionWrapper.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            actionTitleLabel.leadingAnchor.constraint(equalTo: actionWrapper.leadingAnchor, constant: .mediumLargeSpacing),
            actionTitleLabel.trailingAnchor.constraint(equalTo: actionWrapper.trailingAnchor, constant: -.mediumLargeSpacing),
            actionTitleLabel.topAnchor.constraint(equalTo: actionWrapper.topAnchor),

            actionDescriptionLabel.leadingAnchor.constraint(equalTo: actionWrapper.leadingAnchor, constant: .mediumLargeSpacing),
            actionDescriptionLabel.trailingAnchor.constraint(equalTo: actionWrapper.trailingAnchor, constant: -.mediumLargeSpacing),
            actionDescriptionLabel.topAnchor.constraint(equalTo: actionTitleLabel.bottomAnchor, constant: .mediumSpacing),

            actionButton.leadingAnchor.constraint(equalTo: actionWrapper.leadingAnchor, constant: .mediumLargeSpacing),
            actionButton.topAnchor.constraint(equalTo: actionDescriptionLabel.bottomAnchor, constant: 24),

            gradientWrapper.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumSpacing),
            gradientWrapper.leadingAnchor.constraint(equalTo: actionWrapper.leadingAnchor),
            gradientWrapper.trailingAnchor.constraint(equalTo: actionWrapper.trailingAnchor),
            gradientWrapper.bottomAnchor.constraint(equalTo: actionWrapper.bottomAnchor)
            ])

        if shouldShowAction {
            actionWrapperHeightConstraint.isActive = true
        } else {
            actionWrapperHideConstraint.isActive = true
        }

        // If price is not provided
        // then the detailLabel should be centered with the ribbonView

        if model?.price == nil {
            NSLayoutConstraint.activate([
                detailLabel.centerYAnchor.constraint(equalTo: (ribbonView?.centerYAnchor ?? centerYAnchor)),
                detailLabel.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView?.leadingAnchor ?? trailingAnchor),
                ])
        } else {
            guard let priceLabel = priceLabel else { return }
            contentView.addSubview(priceLabel)
            NSLayoutConstraint.activate([
                priceLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                priceLabel.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumSpacing),
                priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: ribbonView?.leadingAnchor ?? trailingAnchor, constant: -.mediumSpacing),

                detailLabel.topAnchor.constraint(equalTo: (ribbonView?.bottomAnchor ?? titleLabel.bottomAnchor), constant: .smallSpacing),
                detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
        }

        if model?.actionModel?.cancelButtonTitle != nil {
            actionWrapper.addSubview(cancelButton)
            NSLayoutConstraint.activate([
                cancelButton.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
                cancelButton.leadingAnchor.constraint(equalTo: actionButton.trailingAnchor, constant: .smallSpacing)
                ])
        }
    }

    private func teardownView() {
        adImageView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        priceLabel?.removeFromSuperview()
        ribbonView?.removeFromSuperview()
        detailLabel.removeFromSuperview()
    }

    private func setupRibbonView(with status: UserAdStatus) {
        ribbonView?.removeFromSuperview()
        switch status {
        // Draft ad states
        case .draft, .denied: ribbonView = RibbonView(style: .warning, with: status.rawValue)
        case .awaitingPayment: ribbonView = RibbonView(style: .warning, with: status.rawValue)

        // Active ad states
        case .active: ribbonView = RibbonView(style: .success, with: status.rawValue)
        case .control: ribbonView = RibbonView(style: .success, with: status.rawValue)

        // Inactive ad states
        case .deactive, .dateExpiry: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .expired: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .inactive: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        case .sold: ribbonView = RibbonView(style: .warning, with: status.rawValue)

        // Edge case - the provided status is not supported in the UserAdStatus enum
        case .unknown: ribbonView = RibbonView(style: .disabled, with: status.rawValue)
        }

        if let ribbon = ribbonView {
            ribbon.translatesAutoresizingMaskIntoConstraints = false

            ribbon.setContentCompressionResistancePriority(.required, for: .horizontal)
            ribbon.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            ribbon.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)

            adWrapperView.addSubview(ribbon)
            NSLayoutConstraint.activate([
                ribbon.trailingAnchor.constraint(equalTo: adWrapperView.trailingAnchor, constant: -.mediumSpacing),
                ribbon.centerYAnchor.constraint(equalTo: adWrapperView.centerYAnchor),
                ])
        }
    }

    // MARK: - Superclass Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientWrapper.bounds
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        teardownView()

        let unusedCell = UserAdsListViewCell()

        if let model = model {
            dataSource?.userAdsListViewCell(unusedCell, cancelLoadingImageForModel: model, imageWidth: adImageView.frame.size.width)
        }
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            teardownView()

            titleLabel.text = model.title
            priceLabel?.text = model.price
            detailLabel.text = model.detail
            userAdStatus = UserAdStatus(rawValue: model.status) ?? .unknown
            accessibilityLabel = model.accessibilityLabel

            actionTitleLabel.text = model.actionModel?.title
            actionDescriptionLabel.text = model.actionModel?.description
            actionButton.setTitle(model.actionModel?.buttonTitle, for: .normal)
            cancelButton.setTitle(model.actionModel?.cancelButtonTitle, for: .normal)

            setupRibbonView(with: userAdStatus)
            setupView()
        }
    }

    // MARK: - Public
    /// Loads a given image provided that the imagePath in the `model` is valid.

    private func loadImage(_ model: UserAdsListViewModel) {
        guard let dataSource = dataSource, model.imagePath != nil else {
            loadingColor = .clear
            adImageView.image = defaultImage
            return
        }

        adImageView.backgroundColor = loadingColor

        let unusedCell = UserAdsListViewCell()
        dataSource.userAdsListViewCell(unusedCell, loadImageForModel: model, imageWidth: frame.size.width) { [weak self] image in
            self?.adImageView.backgroundColor = .clear
            self?.adImageView.image = image ?? self?.defaultImage
        }

    }

    @objc private func buttonTapped(_ sender: Button) {
        delegate?.userAdsListEmphasizedActionCell(self, buttonWasTapped: sender)
    }

    @objc private func cancelButtonTapped(_ sender: Button) {
        delegate?.userAdsListEmphasizedActionCell(self, cancelButtonWasTapped: sender)
    }
}

extension UserAdsListEmphasizedActionCell: ImageLoading {
    public func loadImage() {
        if let model = model {
            loadImage(model)
        }
    }
}
