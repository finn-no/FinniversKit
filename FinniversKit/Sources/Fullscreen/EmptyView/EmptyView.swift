//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import CoreMotion
import UIKit
import Warp

public protocol EmptyViewDelegate: AnyObject {
    func emptyView(_ emptyView: EmptyView, didSelectActionButton button: Button)
    func emptyView(_ emptyView: EmptyView, didMoveObjectView view: UIView)
}

public enum EmptyViewShapeType { // Deprecated
    case `default`
    case christmas
    case none
}

@available(*, deprecated, message: "This view is deprecated. Use `StateViews.EmptyStateView` instead")
public class EmptyView: UIView {

    // MARK: - Other private attributes

    private lazy var headerLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        button.isHidden = true // Default is hidden. When a title is set it will be displayed.
        return button
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: EmptyViewDelegate?

    public var header: String = "" {
        didSet {
            headerLabel.text = header
            headerLabel.accessibilityLabel = header
        }
    }

    public var message: String = "" {
        didSet {
            messageLabel.text = message
            messageLabel.accessibilityLabel = message
        }
    }

    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    public var actionButtonTitle: String = "" {
        didSet {
            actionButton.setTitle(actionButtonTitle, for: .normal)
            actionButton.accessibilityLabel = actionButtonTitle
            actionButton.isHidden = actionButtonTitle.isEmpty
        }
    }

    // MARK: - Init

    public init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Deprecated

    @available(*, deprecated, message: "shapeType parameter is not supported anymore and should be removed")
    public init(shapeType: EmptyViewShapeType = .default) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background

        addSubview(headerLabel)
        addSubview(messageLabel)
        addSubview(imageView)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing800),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),

            messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Warp.Spacing.spacing400),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),

            imageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: Warp.Spacing.spacing400),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),

            actionButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Warp.Spacing.spacing400),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400)
        ])
    }

    // MARK: - Actions

    @objc private func performAction() {
        delegate?.emptyView(self, didSelectActionButton: actionButton)
    }
}
