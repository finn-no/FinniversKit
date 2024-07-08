//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit
import Warp

public final class NativeAdvertRecommendationView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031

    private lazy var container: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = Warp.Spacing.spacing100
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var ribbon = NativeAdvertRibbon(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let view = Label(style: .body, withAutoLayout: true)
        view.numberOfLines = 3
        return view
    }()

    private lazy var settingsButton: UIButton = {
        let button = CogWheelButton(alignment: .right, autoLayout: true)
        button.addTarget(self, action: #selector(handleSettingsButtonTap), for: .touchUpInside)
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

    // MARK: - Setup

    private func setup() {
        addSubview(container)
        container.fillInSuperview()

        container.addSubview(imageView)
        container.addSubview(logoView)
        container.addSubview(ribbon)
        container.addSubview(titleLabel)

        imageView.addSubview(settingsButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / imageAspectRatio),
            imageView.widthAnchor.constraint(equalTo: container.widthAnchor),

            logoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            logoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 35),
            logoView.heightAnchor.constraint(equalToConstant: 35),

            ribbon.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Warp.Spacing.spacing100),
            ribbon.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            ribbon.trailingAnchor.constraint(equalTo: container.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: ribbon.bottomAnchor, constant: Warp.Spacing.spacing100),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: logoView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            settingsButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
        ])
    }

    public func configure(with model: NativeAdvertViewModel) {
        if let imageUrl = model.mainImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: imageView)
        }

        if let imageUrl = model.logoImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: logoView)
        }

        titleLabel.text = model.title

        ribbon.configure(with: model.ribbon)
    }

    // MARK: - Private methods

    @objc private func handleSettingsButtonTap() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }

}
