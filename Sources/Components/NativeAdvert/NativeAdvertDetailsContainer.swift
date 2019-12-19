//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

internal final class NativeAdvertDetailsContainer: UIView {

    // MARK: - Private properties

    private var logoSizeRegular: CGFloat = 50
    private var logoSizeCompact: CGFloat = 40

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
        let view = Label(style: .caption, withAutoLayout: true)
        view.numberOfLines = 2
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        view.numberOfLines = 3
        return view
    }()

    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Constraints

    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        container.topAnchor.constraint(equalTo: topAnchor),
        container.leadingAnchor.constraint(equalTo: leadingAnchor),
        container.bottomAnchor.constraint(equalTo: bottomAnchor),
        container.trailingAnchor.constraint(equalTo: trailingAnchor),

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

        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
        descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        descriptionLabel.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -.mediumSpacing),

        logoView.bottomAnchor.constraint(equalTo: bottomAnchor),
        logoView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        logoView.widthAnchor.constraint(equalToConstant: logoSizeCompact),
        logoView.heightAnchor.constraint(equalToConstant: logoSizeCompact),

        titleLabel.topAnchor.constraint(equalTo: adRibbonContainer.bottomAnchor, constant: .mediumSpacing),

        descriptionLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        logoView.widthAnchor.constraint(equalToConstant: logoSizeRegular),
        logoView.heightAnchor.constraint(equalToConstant: logoSizeRegular),

        titleLabel.topAnchor.constraint(equalTo: adRibbonContainer.bottomAnchor, constant: .mediumLargeSpacing),

        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor),
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
        container.addSubview(descriptionLabel)
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
        descriptionLabel.text = model.description
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
            titleLabel.font = .body
            descriptionLabel.font = .caption
        } else {
            titleLabel.font = .caption
            descriptionLabel.font = .detail
        }
    }

}
