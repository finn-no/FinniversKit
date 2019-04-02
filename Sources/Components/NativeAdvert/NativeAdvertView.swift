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

    // MARK: - UI properties

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.setContentHuggingPriority(.required, for: .vertical)
        return view
    }()

    private lazy var mainImageView: UIImageView = {
        let imageView = ResizeableImageView(frame: .zero)
        imageView.delegate = self
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var imageViewAspectRatioConstraint: NSLayoutConstraint?

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var bottomContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.setContentHuggingPriority(.required, for: .horizontal)
        return view
    }()

    private lazy var sponsoredByLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private lazy var sponsoredByBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .banana
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
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
                if largeTitles {
                    titleLabel.font = UIFont.bodyStrong.withSize(16)
                    sponsoredByLabel.font = UIFont.body.withSize(11)
                } else {
                    titleLabel.font = UIFont.bodyStrong.withSize(13)
                    sponsoredByLabel.font = UIFont.body.withSize(10)
                }
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
        build(viewModel: viewModel)
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
            contentView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            contentView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: containerMaxWidth),
            contentView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),

            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: containerMargin),
            mainImageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: containerMargin),
            mainImageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -containerMargin),
            mainImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: mainImageView.leadingAnchor),

            mainImageView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: -sponsoredByPaddingTop),
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
        setupFonts(largeTitles: largeTitles)
    }

    func build(viewModel: NativeAdvertViewModel) {
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

    func setupFonts(largeTitles: Bool) {
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

extension NativeAdvertView: ResizeableImageViewDelegate {
    fileprivate func resizeableImageView(_ imageView: ResizeableImageView, didChangeImage image: UIImage?) {
        guard let image = image, imageViewAspectRatioConstraint == nil else {
            return
        }
        let widthConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
        NSLayoutConstraint.activate([widthConstraint])
        imageViewAspectRatioConstraint = widthConstraint
    }
}

private protocol ResizeableImageViewDelegate: AnyObject {
    func resizeableImageView(_ imageView: ResizeableImageView, didChangeImage image: UIImage?)
}

private class ResizeableImageView: UIImageView {
    weak var delegate: ResizeableImageViewDelegate?

    override var image: UIImage? {
        didSet {
            delegate?.resizeableImageView(self, didChangeImage: image)
        }
    }
}

