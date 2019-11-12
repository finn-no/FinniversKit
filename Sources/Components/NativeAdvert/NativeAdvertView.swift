//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let containerMaxWidth: CGFloat = 400
    private let logoSize: CGFloat = 35

    // See specification on:
    // https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031
    private let imageAspectRatio: CGFloat = (1200.0 / 627)

    // MARK: - UI properties

    private lazy var contentView: UIView = UIView(withAutoLayout: true)

    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    private lazy var bottomContainerView: UIView = UIView(withAutoLayout: true)

    private lazy var sponsoredByLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var sponsoredByBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgAlert
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var settingsButton: UIButton = {
        let button = CogWheelButton(corners: [.bottomRight], autoLayout: true)
        button.addTarget(self, action: #selector(handleSettingsButtonTap), for: .touchUpInside)
        return button
    }()

//    private var largeTitles = false {
//        didSet {
//            if oldValue != largeTitles {
//                setupFonts()
//            }
//        }
//    }

    // MARK: - Init

    public override init(frame: CGRect) {
        fatalError("init(frame:) not implemented")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    public init(viewModel: NativeAdvertViewModel, imageDelegate: NativeAdvertImageDelegate?) {
        super.init(frame: .zero)
        self.imageDelegate = imageDelegate
        setup()
        configure(viewModel: viewModel)
    }

//    public override func layoutSubviews() {
//        largeTitles = frame.width >= 400
//        super.layoutSubviews()
//    }

    @objc private func handleSettingsButtonTap() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }
}

private extension NativeAdvertView {
    func setup() {
        addSubview(contentView)

        contentView.addSubview(mainImageView)
        contentView.addSubview(bottomContainerView)

        bottomContainerView.addSubview(sponsoredByBackgroundView)
        bottomContainerView.addSubview(titleLabel)
        bottomContainerView.addSubview(logoImageView)

        sponsoredByBackgroundView.addSubview(sponsoredByLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumSpacing),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumSpacing),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: containerMaxWidth),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),

            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / imageAspectRatio),
            mainImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            bottomContainerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            logoImageView.widthAnchor.constraint(equalToConstant: logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize),
            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),

            sponsoredByBackgroundView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: .mediumSpacing),
            sponsoredByBackgroundView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            sponsoredByBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: bottomContainerView.trailingAnchor),

            sponsoredByLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.topAnchor, constant: .verySmallSpacing),
            sponsoredByLabel.leadingAnchor.constraint(equalTo: sponsoredByBackgroundView.leadingAnchor, constant: .verySmallSpacing),
            sponsoredByLabel.trailingAnchor.constraint(equalTo: sponsoredByBackgroundView.trailingAnchor, constant: -.verySmallSpacing),
            sponsoredByLabel.bottomAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: -.verySmallSpacing),

            titleLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: .verySmallSpacing),
            titleLabel.widthAnchor.constraint(equalTo: mainImageView.widthAnchor, constant: -.mediumSpacing - logoSize - .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
        ])

//        setupFonts()
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

//    func setupFonts() {
//        if largeTitles {
//            titleLabel.style = .bodyStrong
//            sponsoredByLabel.font = sponsoredByFont(withSize: 11)
//        } else {
//            titleLabel.font = titleFont(withSize: 13)
//            sponsoredByLabel.font = sponsoredByFont(withSize: 10)
//        }
//    }
//
//    func titleFont(withSize size: CGFloat) -> UIFont {
//        let bodyFont = UIFont.body
//        let fontDescriptorSymbolicTraits: UIFontDescriptor.SymbolicTraits = [bodyFont.fontDescriptor.symbolicTraits, .traitBold]
//        if let boldFontDescriptor = bodyFont.fontDescriptor.withSymbolicTraits(fontDescriptorSymbolicTraits) {
//            let boldedFont = UIFont(descriptor: boldFontDescriptor, size: size)
//            return boldedFont
//        }
//        return UIFont.body.withSize(size)
//    }
//
//    func sponsoredByFont(withSize size: CGFloat) -> UIFont {
//        return UIFont.body.withSize(size)
//    }
}
