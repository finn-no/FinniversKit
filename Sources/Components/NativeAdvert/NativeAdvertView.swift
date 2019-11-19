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

    private lazy var bottomContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var labelContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var sponsoredByLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 1
        label.textColor = .textToast
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
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
        func clamp(width: CGFloat) -> CGFloat {
            max(0, min(NativeAdvertView.containerMaxWidth, width))
        }

        let width = clamp(width: targetSize.width)

        var height = NativeAdvertView.containerMargin * 2
        height +=  NativeAdvertView.imageHeight(forWidth: width)
        height += .mediumSpacing
        height += NativeAdvertView.sponsoredByLabelHeight(forWidth: width, withText: viewModel.sponsoredText ?? "")
        height += .mediumSpacing
        height += NativeAdvertView.titleLabelHeight(forWidth: width, withText: viewModel.title ?? "")

        return CGSize(width: width, height: height)
    }
}

private extension NativeAdvertView {
    func setup() {
        addSubview(contentView)

        contentView.addSubview(mainImageView)
        contentView.addSubview(bottomContainerView)
        contentView.addSubview(settingsButton)

        bottomContainerView.addSubview(labelContainer)
        bottomContainerView.addSubview(logoImageView)

        labelContainer.addSubview(sponsoredByBackgroundView)
        labelContainer.addSubview(titleLabel)

        sponsoredByBackgroundView.addSubview(sponsoredByLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: NativeAdvertView.containerMaxWidth),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),

            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: NativeAdvertView.containerMargin),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / NativeAdvertView.imageAspectRatio),
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -NativeAdvertView.containerMargin * 2),

            bottomContainerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: NativeAdvertView.containerMargin),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -NativeAdvertView.containerMargin),
            bottomContainerView.heightAnchor.constraint(lessThanOrEqualTo: labelContainer.heightAnchor),

            labelContainer.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            labelContainer.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            labelContainer.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            labelContainer.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, constant: -NativeAdvertView.sizeOfLogoAndMargin),

            logoImageView.widthAnchor.constraint(equalToConstant: NativeAdvertView.logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: NativeAdvertView.logoSize),
            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -NativeAdvertView.containerMargin),
            logoImageView.centerYAnchor.constraint(equalTo: labelContainer.centerYAnchor),

            sponsoredByBackgroundView.topAnchor.constraint(equalTo: labelContainer.topAnchor, constant: .mediumSpacing),
            sponsoredByBackgroundView.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor),

            sponsoredByLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.topAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.leadingAnchor.constraint(equalTo: sponsoredByBackgroundView.leadingAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.trailingAnchor.constraint(equalTo: sponsoredByBackgroundView.trailingAnchor, constant: -NativeAdvertView.sponsoredByLabelInset),
            sponsoredByLabel.bottomAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: -NativeAdvertView.sponsoredByLabelInset),

            titleLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor, constant: NativeAdvertView.sponsoredByLabelInset),
            titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor, constant: -NativeAdvertView.containerMargin),
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

    private static var sizeOfLogoAndMargin: CGFloat {
        containerMargin + logoSize + .mediumLargeSpacing + sponsoredByLabelInset
    }

    private static func titleLabelFont(forWidth width: CGFloat) -> UIFont {
        width >= 400 ? .title3 : .bodyStrong
    }

    private static func sponsoredByLabelFont(forWidth width: CGFloat) -> UIFont {
        width >= 400 ? .caption : .detail
    }

    private static func titleLabelHeight(forWidth width: CGFloat, withText text: String) -> CGFloat {
        let titleFont = titleLabelFont(forWidth: width)
        return text.height(withConstrainedWidth: width - sizeOfLogoAndMargin, font: titleFont)
    }

    private static func sponsoredByLabelHeight(forWidth width: CGFloat, withText text: String) -> CGFloat {
        let sponsoredByFont = sponsoredByLabelFont(forWidth: width)
        var height = sponsoredByLabelInset * 2
        height += text.height(withConstrainedWidth: width - sizeOfLogoAndMargin, font: sponsoredByFont)
        return height
    }

    private static func imageHeight(forWidth width: CGFloat) -> CGFloat {
        round((width - (containerMargin * 2)) / imageAspectRatio)
    }
}
