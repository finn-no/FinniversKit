//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let containerMargin: CGFloat = 8
    private let containerMaxWidth: CGFloat = 400
    private let logoSize: CGFloat = 35
    private let logoPaddingLeft: CGFloat = 15
    private let sponsoredByPaddingTop: CGFloat = 5
    private let sponsoredByInset: CGFloat = 3

    // See specification on:
    // https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031
    private let imageAspectRatio: CGFloat = (1200.0 / 627)

    // MARK: - UI properties

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

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
        view.setContentCompressionResistancePriority(.required, for: .vertical)
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

    private var largeTitles = false {
        didSet {
            if oldValue != largeTitles {
                setupFonts()
            }
        }
    }

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

    public override func layoutSubviews() {
        largeTitles = frame.width >= 400
        super.layoutSubviews()
    }

    @objc private func handleSettingsButtonTap() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }
}

private extension NativeAdvertView {
    func setup() {
        addSubview(contentView)
        contentView.addSubview(mainImageView)
        contentView.addSubview(bottomContainerView)
        contentView.addSubview(settingsButton)
        bottomContainerView.addSubview(logoImageView)
        bottomContainerView.addSubview(sponsoredByBackgroundView)
        sponsoredByBackgroundView.addSubview(sponsoredByLabel)
        bottomContainerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: containerMaxWidth),

            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerMargin),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: containerMargin),
            mainImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -containerMargin),
            mainImageView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -sponsoredByPaddingTop),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / imageAspectRatio),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),

            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: containerMargin),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -containerMargin),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -containerMargin),

            sponsoredByBackgroundView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            sponsoredByBackgroundView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            sponsoredByBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: logoImageView.leadingAnchor, constant: -logoPaddingLeft),

            sponsoredByLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.topAnchor, constant: sponsoredByInset),
            sponsoredByLabel.leadingAnchor.constraint(equalTo: sponsoredByBackgroundView.leadingAnchor, constant: sponsoredByInset),
            sponsoredByLabel.trailingAnchor.constraint(equalTo: sponsoredByBackgroundView.trailingAnchor, constant: -sponsoredByInset),
            sponsoredByLabel.bottomAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: -sponsoredByInset),

            titleLabel.topAnchor.constraint(equalTo: sponsoredByBackgroundView.bottomAnchor, constant: sponsoredByPaddingTop),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: sponsoredByInset),
            titleLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -logoPaddingLeft),
            titleLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),

            logoImageView.widthAnchor.constraint(equalToConstant: logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: logoSize),
            logoImageView.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor)
        ])

        setupFonts()
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

    func setupFonts() {
        if largeTitles {
            titleLabel.font = titleFont(withSize: 16)
            sponsoredByLabel.font = sponsoredByFont(withSize: 11)
        } else {
            titleLabel.font = titleFont(withSize: 13)
            sponsoredByLabel.font = sponsoredByFont(withSize: 10)
        }
    }

    func titleFont(withSize size: CGFloat) -> UIFont {
        let bodyFont = UIFont.body
        let fontDescriptorSymbolicTraits: UIFontDescriptor.SymbolicTraits = [bodyFont.fontDescriptor.symbolicTraits, .traitBold]
        if let boldFontDescriptor = bodyFont.fontDescriptor.withSymbolicTraits(fontDescriptorSymbolicTraits) {
            let boldedFont = UIFont(descriptor: boldFontDescriptor, size: size)
            return boldedFont
        }
        return UIFont.body.withSize(size)
    }

    func sponsoredByFont(withSize size: CGFloat) -> UIFont {
        return UIFont.body.withSize(size)
    }
}
