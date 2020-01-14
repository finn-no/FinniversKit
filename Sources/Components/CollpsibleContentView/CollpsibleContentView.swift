//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class CollapsibleContentView: UIView {
    // MARK: - Public properties

    // MARK: - Private properties

    private lazy var innerContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.preservesSuperviewLayoutMargins = true
        return view
    }()

    private lazy var headerView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        return label
    }()

    private lazy var collapseIndicatorView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = indicatorImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconSecondary
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleContent)))
        return imageView
    }()

    private lazy var fullHeightConstraint: NSLayoutConstraint = {
        let constraint = heightAnchor.constraint(equalTo: innerContainerView.heightAnchor)
        constraint.priority = .defaultHigh
        return constraint
    }()

    var isCollapsed: Bool {
        !fullHeightConstraint.isActive
    }

    private var indicatorImage: UIImage? {
        let assetName: FinniversImageAsset = isCollapsed ? .arrowDown : .arrowUp
        return UIImage(named: assetName)
    }

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public func configure(with title: String, contentView: UIView) {
        titleLabel.text = title
        addContentView(contentView)
    }

    // MARK: - Private methods

    private func setup() {
        clipsToBounds = true

        headerView.addArrangedSubview(titleLabel)
        headerView.addArrangedSubview(collapseIndicatorView)

        addSubview(innerContainerView)
        innerContainerView.addSubview(headerView)

        let compactHeightConstraint = heightAnchor.constraint(
            equalTo: headerView.heightAnchor,
            multiplier: 1.0,
            constant: layoutMargins.top + layoutMargins.bottom
        )
        compactHeightConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            innerContainerView.topAnchor.constraint(equalTo: topAnchor),
            innerContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            innerContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            innerContainerView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor),

            headerView.topAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.trailingAnchor),
            compactHeightConstraint,
        ])

        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleContent)))
    }

    private func addContentView(_ contentView: UIView) {
        innerContainerView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: .mediumSpacing),
            contentView.leadingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.bottomAnchor),
        ])
    }

    @objc private func toggleContent() {
        fullHeightConstraint.isActive.toggle()

        let newImage = indicatorImage
        UIView.transition(
            with: collapseIndicatorView,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: { self.collapseIndicatorView.image = newImage }
        )

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.superview?.layoutIfNeeded()
        })
    }
}
