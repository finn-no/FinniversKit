//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class NativeAdvertGridView: UIView {

    // MARK: - Public properties

    public weak var delegate: NativeAdvertViewDelegate?

    // MARK: - Private properties

    private let imageAspectRatio: CGFloat = (1200.0 / 627) // Specification at: https://annonseweb.schibsted.no/nb-no/product/finn-native-ads-16031

    private lazy var container: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = .mediumSpacing
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var detailsContainer = NativeDetailsContainer(withAutoLayout: true)

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

        settingsButton.topAnchor.constraint(equalTo: container.topAnchor),
        settingsButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        imageView.topAnchor.constraint(equalTo: container.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1 / imageAspectRatio),

        detailsContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor),
        detailsContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor),

        detailsContainer.topAnchor.constraint(equalTo: imageView.bottomAnchor),
        detailsContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        imageView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.5),
        imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

        detailsContainer.topAnchor.constraint(equalTo: container.topAnchor),
        detailsContainer.leadingAnchor.constraint(equalTo: imageView.trailingAnchor),
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
        setColors()
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

    private func setColors() {
        if traitCollection.horizontalSizeClass == .regular {
            detailsContainer.backgroundColor = .bgTertiary
        } else {
            detailsContainer.backgroundColor = .bgPrimary
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
        setColors()
    }

}

private class NativeDetailsContainer: UIView {

    // MARK: - Private properties

    private var logoSize: CGFloat = 50

    private lazy var container = UIView(withAutoLayout: true)

    private lazy var adRibbonContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.borderWidth = 1
        view.layer.borderColor = .tableViewSeparator
        view.layer.cornerRadius = .smallSpacing
        return view
    }()

    private lazy var adRibbon: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        return view
    }()

    private lazy var companyLabel: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        view.textColor = .textAction
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = Label(style: .body, withAutoLayout: true)
        view.numberOfLines = 2
        return view
    }()

    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Constraints

    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        adRibbonContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        adRibbonContainer.topAnchor.constraint(equalTo: container.topAnchor),

        adRibbon.topAnchor.constraint(equalTo: adRibbonContainer.topAnchor, constant: .verySmallSpacing),
        adRibbon.leadingAnchor.constraint(equalTo: adRibbonContainer.leadingAnchor, constant: .smallSpacing),
        adRibbon.bottomAnchor.constraint(equalTo: adRibbonContainer.bottomAnchor, constant: -.verySmallSpacing),
        adRibbon.trailingAnchor.constraint(equalTo: adRibbonContainer.trailingAnchor, constant: -.smallSpacing),

        companyLabel.centerYAnchor.constraint(equalTo: adRibbonContainer.centerYAnchor),
        companyLabel.leadingAnchor.constraint(equalTo: adRibbonContainer.trailingAnchor, constant: .smallSpacing),

        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -.mediumSpacing),

        logoView.widthAnchor.constraint(equalToConstant: logoSize),
        logoView.heightAnchor.constraint(equalToConstant: logoSize),
        logoView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        logoView.trailingAnchor.constraint(equalTo: container.trailingAnchor)
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        heightAnchor.constraint(greaterThanOrEqualToConstant: logoSize + .mediumLargeSpacing),

        titleLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: .mediumSpacing),
        titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),

        container.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        container.leadingAnchor.constraint(equalTo: leadingAnchor),
        container.trailingAnchor.constraint(equalTo: trailingAnchor)
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        titleLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: .mediumLargeSpacing),
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor),

        container.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
        container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(container)

        adRibbonContainer.addSubview(adRibbon)

        container.addSubview(adRibbonContainer)
        container.addSubview(companyLabel)
        container.addSubview(titleLabel)
        container.addSubview(logoView)

        NSLayoutConstraint.activate(sharedConstraints)

        setConstraints()
        setFonts()
    }

    func configure(with model: NativeAdvertViewModel, andImageDelegate imageDelegate: NativeAdvertImageDelegate?) {
        if let imageUrl = model.logoImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: logoView)
        }

        adRibbon.text = model.ribbonText
        companyLabel.text = model.sponsoredBy
        titleLabel.text = model.title
    }

    // MARK: - Overrides

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setConstraints()
        setFonts()
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

    private func setFonts() {
        if traitCollection.horizontalSizeClass == .regular {
            titleLabel.font = .title2
        } else {
            titleLabel.font = .body
        }
    }

}
