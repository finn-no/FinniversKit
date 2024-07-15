//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

public final class NativeAdvertContentView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?
    public weak var imageDelegate: NativeAdvertImageDelegate?

    // MARK: - Private properties

    private let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031

    private lazy var container: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = Warp.Spacing.spacing100
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var detailsContainer = NativeAdvertDetailsContainer(withAutoLayout: true)

    private lazy var settingsButton: UIButton = {
        let button = CogWheelButton(alignment: .right, autoLayout: true)
        button.addTarget(self, action: #selector(handleSettingsButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Constraints

    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        container.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100),
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

        settingsButton.topAnchor.constraint(equalTo: container.topAnchor),
        settingsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        imageView.topAnchor.constraint(equalTo: container.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / imageAspectRatio),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor),

        detailsContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Warp.Spacing.spacing100),
        detailsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Warp.Spacing.spacing100),
        detailsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Warp.Spacing.spacing200),
        detailsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Warp.Spacing.spacing200)
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5),
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

        detailsContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: Warp.Spacing.spacing200),
        detailsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Warp.Spacing.spacing200),
        detailsContainer.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Warp.Spacing.spacing200),
        detailsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Warp.Spacing.spacing200)
    ]

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
        container.backgroundColor = .backgroundSubtle

        addSubview(container)
        container.addSubview(imageView)
        container.addSubview(detailsContainer)
        container.addSubview(settingsButton)

        NSLayoutConstraint.activate(sharedConstraints)
        setSizeClassConstraints()
    }

    public func configure(with model: NativeAdvertViewModel) {
        if let imageUrl = model.mainImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: imageView)
        }

        detailsContainer.configure(with: model, andImageDelegate: imageDelegate)
    }

    private func setSizeClassConstraints() {
        if traitCollection.horizontalSizeClass == .regular {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        }
    }

    // MARK: - Private methods

    @objc private func handleSettingsButtonTap() {
        delegate?.nativeAdvertViewDidSelectSettingsButton()
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setSizeClassConstraints()
    }

}
