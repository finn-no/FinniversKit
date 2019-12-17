//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeAdvertListView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?

    // MARK: - Private properties

    private let imageWidthCompact: CGFloat = 130
    private let imageWidthRegular: CGFloat = 195
    private let detailsContainerMinimumHeightCompact: CGFloat = 112
    private let detailsContainerMinimumHeightRegular: CGFloat = 162

    private let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031

    private lazy var container = UIView(withAutoLayout: true)

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = .mediumSpacing
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
        container.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        container.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor),

        settingsButton.topAnchor.constraint(equalTo: container.topAnchor),
        settingsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        imageView.topAnchor.constraint(equalTo: container.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / imageAspectRatio),

        detailsContainer.topAnchor.constraint(equalTo: container.topAnchor),
        detailsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -.mediumSpacing),
        detailsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),

        detailsContainer.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .smallSpacing),
        detailsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: detailsContainerMinimumHeightCompact),

        imageView.widthAnchor.constraint(equalToConstant: imageWidthCompact),
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),

        detailsContainer.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumLargeSpacing),
        detailsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: detailsContainerMinimumHeightRegular),

        imageView.widthAnchor.constraint(equalToConstant: imageWidthRegular),
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
        addSubview(container)

        container.addSubview(imageView)
        container.addSubview(detailsContainer)

        container.addSubview(settingsButton)

        NSLayoutConstraint.activate(sharedConstraints)

        setConstraints()
    }

    public func configure(with model: NativeAdvertViewModel, andImageDelegate imageDelegate: NativeAdvertImageDelegate?) {
        if let imageUrl = model.mainImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: imageView)
        }

        detailsContainer.configure(with: model, andImageDelegate: imageDelegate)
    }

    private func setConstraints() {
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
        setConstraints()
    }

}
