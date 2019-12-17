//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeContentAdvertView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - UI properties

    private lazy var containerView = UIView(withAutoLayout: true)

    private lazy var cardView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = NativeContentAdvertView.cornerRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var mainImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var bottomContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = UIColor(r: 248, g: 248, b: 248)
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: NativeContentAdvertView.titleLabelStyle, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .textToast
        return label
    }()

    private lazy var settingsButton: NativeContentSettingsButton = {
        let button = NativeContentSettingsButton(cornerRadius: NativeContentAdvertView.cornerRadius)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: - Public methods

    public func configure(with model: NativeAdvertViewModel) {
        mainImageView.image = nil
        if let mainImageURL = model.mainImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: mainImageURL, onImageView: mainImageView)
        }

        logoImageView.image = nil
        if let logoImageURL = model.logoImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: logoImageURL, onImageView: logoImageView)
        }

        titleLabel.text = model.title
        settingsButton.text = model.ribbonText
    }


    // MARK: - Private methods

    @objc private func settingsButtonTapped() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }

}

private extension NativeContentAdvertView {
    func setup() {
        addSubview(containerView)

        containerView.addSubview(cardView)

        cardView.addSubview(mainImageView)
        cardView.addSubview(bottomContainerView)
        cardView.addSubview(settingsButton)

        bottomContainerView.addSubview(logoImageView)
        bottomContainerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: NativeContentAdvertView.containerMaxWidth),
            containerView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),

            cardView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: NativeContentAdvertView.padding),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: NativeContentAdvertView.padding),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -NativeContentAdvertView.padding),
            cardView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -NativeContentAdvertView.padding),

            mainImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1.0 / NativeContentAdvertView.imageAspectRatio),

            settingsButton.topAnchor.constraint(equalTo: mainImageView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: mainImageView.trailingAnchor),

            bottomContainerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),

            logoImageView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -NativeContentAdvertView.padding),
            logoImageView.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -NativeContentAdvertView.padding),
            logoImageView.widthAnchor.constraint(equalToConstant: NativeContentAdvertView.logoSize),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: NativeContentAdvertView.padding),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: NativeContentAdvertView.padding),
            titleLabel.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -NativeContentAdvertView.padding)
        ])
    }
}

extension NativeContentAdvertView {
    // MARK: - Static properties

    private static let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031
    private static let cardMaxWidth: CGFloat = 320
    private static let padding: CGFloat = .mediumSpacing
    private static let cornerRadius: CGFloat = .mediumSpacing
    private static let logoSize: CGFloat = 48.0

    private static var containerMaxWidth: CGFloat {
        cardMaxWidth + padding * 2
    }

    private static let titleLabelStyle: Label.Style = .title3

    private static func titleLabelHeight(forWidth width: CGFloat, text: String) -> CGFloat {
        let unavailableSpace = padding + .mediumLargeSpacing + logoSize + padding // Size of logo with margins
        return text.height(withConstrainedWidth: width - unavailableSpace, font: titleLabelStyle.font)
    }

    private static func imageHeight(forWidth width: CGFloat) -> CGFloat {
        width  / imageAspectRatio
    }

}
