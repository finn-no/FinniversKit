//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let viewModel: NativeAdvertViewModel

    // MARK: - UI properties

    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var bottomContainerView = UIView(withAutoLayout: true)

    private lazy var sponsoredByLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 1
        label.textColor = .textToast
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var sponsoredByBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgAlert
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .textPrimary
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = CogWheelButton(corners: [.bottomRight], autoLayout: true)
        button.addTarget(self, action: #selector(handleSettingsButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        fatalError("init(frame:) not implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    public init(viewModel: NativeAdvertViewModel, imageDelegate: NativeAdvertImageDelegate?) {
        self.viewModel = viewModel
        self.imageDelegate = imageDelegate

        super.init(frame: .zero)

        setup()
        configure(viewModel: viewModel)
    }

    @objc private func handleSettingsButtonTap() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        setupFonts(forWidth: frame.width)
        super.layoutSubviews()
    }

    // This override exists because of how we calculate view sizes in our search result list.
    // The search result list needs to know the size of this view before it's added to the view hierarchy
    //
    // All we're given to answer this question is the width attribute in `targetSize`.
    //
    // This implementation may not work for any place other than the search result list, because:
    //   - it assumes `targetSize` contains an accurate targetWidth for this view.
    //   - it ignores any potential targetHeight.
    //   - it ignores both horizontal and vertical fitting priority.
    public override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let width = max(0, min(NativeAdvertView.containerMaxWidth, targetSize.width))

        var height = NativeAdvertView.containerMargin * 2
        height +=  NativeAdvertView.imageHeight(forWidth: width)
        height += .mediumSpacing
        height += NativeAdvertView.sponsoredByLabelHeight(forWidth: width, text: viewModel.sponsoredText ?? "")
        height += .mediumSpacing
        height += NativeAdvertView.titleLabelHeight(forWidth: width, text: viewModel.title ?? "")

        return CGSize(width: width, height: height)
    }
}

private extension NativeAdvertView {
    func setup() {
        addSubview(contentView)

        contentView.addSubview(mainImageView)
        contentView.addSubview(bottomContainerView)
        contentView.addSubview(settingsButton)

        bottomContainerView.addSubview(sponsoredByBackgroundView)
        bottomContainerView.addSubview(titleLabel)
        bottomContainerView.addSubview(logoImageView)

        sponsoredByBackgroundView.addSubview(sponsoredByLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: NativeAdvertView.containerMaxWidth),
            contentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),

            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NativeAdvertView.containerMargin),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NativeAdvertView.containerMargin),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NativeAdvertView.containerMargin),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / NativeAdvertView.imageAspectRatio),

            bottomContainerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NativeAdvertView.containerMargin),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NativeAdvertView.containerMargin),

            logoImageView.widthAnchor.constraint(equalToConstant: NativeAdvertView.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: NativeAdvertView.logoSize),
            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -NativeAdvertView.containerMargin),
            logoImageView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),

            sponsoredByBackgroundView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: .mediumSpacing),
            sponsoredByBackgroundView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            sponsoredByBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: logoImageView.leadingAnchor, constant: -.mediumLargeSpacing),

            sponsoredByLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.topAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.leadingAnchor.constraint(equalTo: sponsoredByBackgroundView.leadingAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.trailingAnchor.constraint(equalTo: sponsoredByBackgroundView.trailingAnchor, constant: -NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.bottomAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: -NativeAdvertView.sponsoredByLabelInset),

            titleLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            titleLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -NativeAdvertView.containerMargin),
        ])

        setupFonts(forWidth: 0)
    }

    func configure(viewModel: NativeAdvertViewModel) {
        mainImageView.image = nil
        if let imageURL = viewModel.mainImageURL {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageURL, onImageView: mainImageView)
        }

        logoImageView.image = nil
        if let imageURL = viewModel.iconImageURL {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageURL, onImageView: logoImageView)
        }

        titleLabel.text = viewModel.title
        sponsoredByLabel.text = viewModel.sponsoredText
    }

    func setupFonts(forWidth width: CGFloat) {
        titleLabel.font = NativeAdvertView.titleLabelFont(forWidth: width)
        sponsoredByLabel.font = NativeAdvertView.sponsoredByLabelFont(forWidth: width)
    }
}

extension NativeAdvertView {
    // MARK: - Static properties
    private static let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031
    private static let containerMargin: CGFloat = .mediumSpacing
    private static let sponsoredByLabelInset: CGFloat = .verySmallSpacing
    private static let containerMaxWidth: CGFloat = 400
    private static let logoSize: CGFloat = 35

    private static var sizeOfLogoWithPadding: CGFloat {
        .mediumLargeSpacing + logoSize + containerMargin
    }

    private static func titleLabelFont(forWidth width: CGFloat) -> UIFont {
        width >= 400 ? .title3 : .body
    }

    private static func sponsoredByLabelFont(forWidth width: CGFloat) -> UIFont {
        width >= 400 ? .caption : .detail
    }

    private static func titleLabelHeight(forWidth width: CGFloat, text: String) -> CGFloat {
        let titleFont = titleLabelFont(forWidth: width)
        return labelHeight(forWidth: width, font: titleFont, text: text)
    }

    private static func sponsoredByLabelHeight(forWidth width: CGFloat, text: String) -> CGFloat {
        let sponsoredByFont = sponsoredByLabelFont(forWidth: width)

        var height = sponsoredByLabelInset * 2
        height += labelHeight(forWidth: width, font: sponsoredByFont, text: text)
        return height
    }

    private static func labelHeight(forWidth width: CGFloat, font: UIFont, text: String) -> CGFloat {
        let unavailableSpace = sponsoredByLabelInset + sizeOfLogoWithPadding // Left inset and size of logo with padding
        return text.height(withConstrainedWidth: width - unavailableSpace, font: font)
    }

    private static func imageHeight(forWidth width: CGFloat) -> CGFloat {
        (width - (containerMargin * 2)) / imageAspectRatio
    }
}
