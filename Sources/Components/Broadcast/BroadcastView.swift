//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast
public class BroadcastView: UIView {
    private lazy var messageLabel: Label = {
        let label = Label(style: Style.labelStyle)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    private lazy var iconImage: UIImage? = {
        let image = UIImage(frameworkImageNamed: Style.iconImageAssetName)

        return image
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = iconImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let imageViewSizeConstraintConstant = CGSize(width: 28, height: 28)

    private lazy var subviewConstraints: [NSLayoutConstraint] = {
        let messageLabelTopAnchorConstraint = messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing)
        messageLabelTopAnchorConstraint.priority = UILayoutPriority(rawValue: 999)

        return [
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.heightAnchor.constraint(equalToConstant: imageViewSizeConstraintConstant.height),
            iconImageView.widthAnchor.constraint(equalToConstant: imageViewSizeConstraintConstant.width),
            iconImageView.centerYAnchor.constraint(equalTo: messageLabel.centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumLargeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            messageLabelTopAnchorConstraint,
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ]
    }()

    /// A property indicating if the BroadcastView is in its presenting state
    public private(set) var isPresenting = false

    /// The message displayed in the presented BroadcastView
    /// This property will be nil if not in presenting state
    public var message: String?

    /// Initalizes a BrodcastView
    /// When initialized the BroadcastView will have a height of zero and appear as invisible/collapsed
    /// Use present(message:animated:completion) to show a message and dismiss(animated:completion) to hide
    /// - Parameter frame:
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - Public

extension BroadcastView {
    /// Presents the message in the BroadcastView
    /// When the message is presented the BroadcastView will expand to the size of the label
    /// containing the text.
    ///
    /// - Parameters:
    ///   - message: The message to present
    ///   - animated: flag to determine if the expansion of the BroadcastView should be animated
    ///   - completion: a closure called when the animation finished
    public func present(message: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        if isPresenting {
            return
        }

        inflate(withMessage: message, animated: animated, completion: completion)

        isPresenting = true
    }

    /// Dismisses the BroadcastView by returning it to its zero height/collapsed state
    ///
    /// - Parameters:
    ///   - animated: flag to determine if the collapse of the BroadcastView should be animated
    ///   - completion: a closure called when the animation finished
    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard isPresenting else {
            return
        }

        deflate(animated: animated, completion: completion)

        isPresenting = false
    }

    /// Returns a calculated height for a BroadcastView by checking the bounding rect for the message.
    ///
    /// - Parameter constrainedWidth: the constrained width to use for calculating the size
    /// - Returns: the calculated height of the BroadcastView
    public func calculatedSize(withConstrainedWidth constrainedWidth: CGFloat) -> CGSize {
        guard let message = message else {
            return CGSize(width: constrainedWidth, height: 0)
        }

        let horizontalSpacings = .mediumLargeSpacing + imageViewSizeConstraintConstant.width + .mediumLargeSpacing + .mediumLargeSpacing
        let rectWidth = constrainedWidth - horizontalSpacings
        let rectSize = CGSize(width: rectWidth, height: CGFloat.infinity)

        let boundingRect = NSString(string: message).boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: messageLabel.labelAttributes, context: nil)

        let verticalSpacing = .mediumLargeSpacing + .mediumLargeSpacing
        let calculatedSize = CGSize(width: constrainedWidth, height: boundingRect.size.height + verticalSpacing)

        return calculatedSize
    }
}

// MARK: - Private

private extension BroadcastView {
    func setup() {
        isAccessibilityElement = true
        backgroundColor = Style.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = Style.containerCornerRadius

        iconImageView.image = iconImage

        addSubview(messageLabel)
        addSubview(iconImageView)

        NSLayoutConstraint.activate(subviewConstraints)

        setClampedHeight(active: true)
    }

    func inflate(withMessage message: String, animated: Bool, completion: (() -> Void)?) {
        self.message = message
        messageLabel.text = message

        setClampedHeight(active: false)

        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.superview?.layoutIfNeeded()
            }) { _ in
                completion?()
            }
        } else {
            superview?.layoutIfNeeded()
            completion?()
        }
    }

    func deflate(animated: Bool, completion: (() -> Void)?) {
        setClampedHeight(active: true)

        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.superview?.layoutIfNeeded()
            }) { [weak self] _ in
                self?.messageLabel.text = ""
                self?.message = nil
                completion?()
            }
        } else {
            superview?.layoutIfNeeded()
            messageLabel.text = ""
            message = nil
            completion?()
        }
    }

    func setClampedHeight(active isActive: Bool) {
        let clampedHeightConstraint: NSLayoutConstraint = {
            let clampedHeightConstraintIdentifier = "heightConstraint"

            if let clampedHeightConstraint = constraints.filter({ $0.identifier == clampedHeightConstraintIdentifier }).first {
                return clampedHeightConstraint
            } else {
                let clampedHeightConstraint = heightAnchor.constraint(equalToConstant: 0)
                clampedHeightConstraint.identifier = clampedHeightConstraintIdentifier

                return clampedHeightConstraint
            }
        }()

        clampedHeightConstraint.isActive = isActive
    }
}
