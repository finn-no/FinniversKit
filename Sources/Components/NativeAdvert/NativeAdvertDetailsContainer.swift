//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

internal final class NativeAdvertDetailsContainer: UIView {

    // MARK: - Private properties

    private var logoSizeRegular: CGFloat = 50
    private var logoSizeCompact: CGFloat = 40

    private lazy var container = UIView(withAutoLayout: true)

    private lazy var nativeAdvertRibbon = NativeAdvertRibbon(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let view = Label(style: .caption, withAutoLayout: true)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
        container.trailingAnchor.constraint(equalTo: logoView.leadingAnchor, constant: -.mediumSpacing),

        nativeAdvertRibbon.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        nativeAdvertRibbon.topAnchor.constraint(equalTo: container.topAnchor),
        nativeAdvertRibbon.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
        descriptionLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        descriptionLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),

        logoView.bottomAnchor.constraint(equalTo: bottomAnchor),
        logoView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        container.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor),

        logoView.widthAnchor.constraint(equalToConstant: logoSizeCompact),
        logoView.heightAnchor.constraint(equalToConstant: logoSizeCompact),

        titleLabel.topAnchor.constraint(equalTo: nativeAdvertRibbon.bottomAnchor, constant: .mediumSpacing),
    ]

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor),

        logoView.widthAnchor.constraint(equalToConstant: logoSizeRegular),
        logoView.heightAnchor.constraint(equalToConstant: logoSizeRegular),

        titleLabel.topAnchor.constraint(equalTo: nativeAdvertRibbon.bottomAnchor, constant: .mediumLargeSpacing),
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
        addSubview(logoView)

        container.addSubview(nativeAdvertRibbon)
        container.addSubview(titleLabel)
        container.addSubview(descriptionLabel)

        NSLayoutConstraint.activate(sharedConstraints)

        setSizeClassConstraints()
        setSizeClassFonts()
    }

    func configure(with model: NativeAdvertViewModel, andImageDelegate imageDelegate: NativeAdvertImageDelegate?) {
        if let imageUrl = model.logoImageUrl {
            imageDelegate?.nativeAdvertView(setImageWithURL: imageUrl, onImageView: logoView)
        }

        titleLabel.text = model.title
        descriptionLabel.text = model.description

        nativeAdvertRibbon.configure(with: model.ribbon)
    }

    // MARK: - Overrides

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        setSizeClassConstraints()
        setSizeClassFonts()
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

    private func setSizeClassFonts() {
        if traitCollection.horizontalSizeClass == .regular {
            titleLabel.font = .body
            descriptionLabel.font = .caption
        } else {
            titleLabel.font = .caption
            descriptionLabel.font = .detail
        }
    }

}
