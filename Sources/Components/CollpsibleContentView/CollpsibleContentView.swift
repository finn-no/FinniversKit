//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol CollapsibleContentViewDelegate: AnyObject {
    func collapsibleContentViewDidTapToggleContent(_ view: CollapsibleContentView)
}

public class CollapsibleContentView: UIView {
    // MARK: - Public properties

    /// By default the component will expand the content automatically when tapping on the header
    /// In cases that you want to control that manually by setting `isExpanded`, then you can make
    /// this value to be `false` (defaults `true`)
    public var expandsAutomatically: Bool = true

    public var isExpanded: Bool {
        get {
            fullHeightConstraint.isActive
        }
        set {
            newValue ? expandContent() : collapseContent()
        }
    }

    public weak var delegate: CollapsibleContentViewDelegate?

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

    private lazy var titleLabel: Label = Label(style: .title3Strong, withAutoLayout: true)

    private lazy var collapseIndicatorImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = indicatorImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconSecondary
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var fullHeightConstraint: NSLayoutConstraint = {
        let constraint = heightAnchor.constraint(equalTo: innerContainerView.heightAnchor)
        constraint.priority = .defaultHigh
        return constraint
    }()

    /// When expanding/collapsing the content, ensure the `fullHeightConstraint` is `active` or `inactive` before
    /// getting this image
    private var indicatorImage: UIImage? {
        let assetName: FinniversImageAsset = isExpanded ? .arrowUp : .arrowDown
        return UIImage(named: assetName)
    }

    private lazy var compactHeightConstraint: NSLayoutConstraint = {
        let constraint = heightAnchor.constraint(
            equalTo: headerView.heightAnchor,
            multiplier: 1.0,
            constant: layoutMargins.top + layoutMargins.bottom
        )
        constraint.priority = .defaultLow
        return constraint
    }()

    private var contentTopConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - UIView overrides

    public override var layoutMargins: UIEdgeInsets {
        didSet {
            compactHeightConstraint.constant = layoutMargins.top + layoutMargins.bottom
            contentTopConstraint?.constant = layoutMargins.bottom
        }
    }

    // MARK: - Public methods

    public func configure(with title: String, contentView: UIView, showExpanded: Bool = false) {
        titleLabel.text = title
        addContentView(contentView)
        if showExpanded {
            expandContent()
        }
    }

    // MARK: - Private methods

    private func setup() {
        clipsToBounds = true

        headerView.addArrangedSubview(titleLabel)
        headerView.addArrangedSubview(collapseIndicatorImageView)

        innerContainerView.addSubview(headerView)
        addSubview(innerContainerView)

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

        let contentTopConstraint = contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: .mediumLargeSpacing)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
            contentTopConstraint,
            contentView.leadingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: innerContainerView.layoutMarginsGuide.bottomAnchor),
        ])
        self.contentTopConstraint = contentTopConstraint
    }

    @objc private func toggleContent() {
        guard expandsAutomatically else {
            delegate?.collapsibleContentViewDidTapToggleContent(self)
            return
        }

        fullHeightConstraint.isActive.toggle()
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseInOut,
            animations: { self.superview?.layoutIfNeeded() }
        )

        let newImage = indicatorImage
        UIView.transition(
            with: collapseIndicatorImageView,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: { self.collapseIndicatorImageView.image = newImage }
        )
    }

    private func expandContent() {
        fullHeightConstraint.isActive = true
        collapseIndicatorImageView.image = indicatorImage
    }

    private func collapseContent() {
        fullHeightConstraint.isActive = false
        collapseIndicatorImageView.image = indicatorImage
    }
}
