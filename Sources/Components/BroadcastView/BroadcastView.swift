//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastViewDelegate: class {
    func broadcastViewDismissButtonTapped(_ broadcastView: BroadcastView)
    func broadcastView(_ broadcastView: BroadcastView, didTapURL url: URL)
}

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast
public final class BroadcastView: UIView {
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isAccessibilityElement = true
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.linkTextAttributes = BroadcastView.Style.linkTextAttributes
        return textView
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

    private lazy var dismissButtonImage: UIImage? = {
        let image = UIImage(frameworkImageNamed: Style.dismissButtonImageAssetName)
        return image
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(dismissButtonImage, for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let imageViewSizeConstraintConstant = CGSize(width: 28, height: 28)

    private lazy var subviewConstraints: [NSLayoutConstraint] = {
        let messageLabelTopAnchorConstraint = messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing + .mediumSpacing)
        messageLabelTopAnchorConstraint.priority = UILayoutPriority(rawValue: 999)

        return [
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.heightAnchor.constraint(equalToConstant: imageViewSizeConstraintConstant.height),
            iconImageView.widthAnchor.constraint(equalToConstant: imageViewSizeConstraintConstant.width),
            iconImageView.centerYAnchor.constraint(equalTo: messageTextView.centerYAnchor),
            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            dismissButton.heightAnchor.constraint(equalToConstant: dismissButtonImage?.size.height ?? 0),
            dismissButton.widthAnchor.constraint(equalToConstant: dismissButtonImage?.size.width ?? 0),
            messageTextView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumLargeSpacing),
            messageTextView.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: 0),
            messageLabelTopAnchorConstraint,
            messageTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(.mediumLargeSpacing + .mediumSpacing)),
        ]
    }()

    public weak var delegate: BroadcastViewDelegate?

    /// A property indicating if the BroadcastView is in its presenting state
    public private(set) var isPresenting = false

    /// The message displayed in the presented BroadcastView
    /// This property will be nil if not in presenting state
    public var message: String? {
        return messageTextView.text
    }

    /// The attributed message displayed in the presented BroadcastView
    /// This property will be nil if not in presenting state
    public var attributedMessage: NSAttributedString? {
        return messageTextView.attributedText
    }

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
    ///   - viewModel: The view model containing the message to present
    ///   - animated: flag to determine if the expansion of the BroadcastView should be animated
    ///   - completion: a closure called when the animation finished
    public func presentMessage(using viewModel: BroadcastViewModel, animated: Bool = true, completion: (() -> Void)? = nil) {
        if isPresenting {
            return
        }

        inflate(using: viewModel, animated: animated, completion: completion)

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
        guard let attributedMessage = attributedMessage else {
            return CGSize(width: constrainedWidth, height: 0)
        }

        let horizontalSpacings = .mediumLargeSpacing + imageViewSizeConstraintConstant.width + .mediumLargeSpacing + (dismissButtonImage?.size.width ?? 0) + .mediumSpacing
        let rectWidth = constrainedWidth - horizontalSpacings
        let rectSize = CGSize(width: rectWidth, height: CGFloat.infinity)
        let boundingRect = attributedMessage.boundingRect(with: rectSize, options: .usesLineFragmentOrigin, context: nil)

        let verticalSpacing = .mediumLargeSpacing + .mediumSpacing + .mediumLargeSpacing + .mediumSpacing
        let calculatedSize = CGSize(width: constrainedWidth, height: boundingRect.height + verticalSpacing)

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

        addSubview(messageTextView)
        addSubview(iconImageView)
        addSubview(dismissButton)

        NSLayoutConstraint.activate(subviewConstraints)

        setClampedHeight(active: true)
    }

    func inflate(using viewModel: BroadcastViewModel, animated: Bool, completion: (() -> Void)?) {
        let attributedText = NSMutableAttributedString(attributedString: viewModel.messageWithHTMLLinksReplacedByAttributedStrings)
        attributedText.addAttributes(BroadcastView.Style.fontAttributes, range: NSMakeRange(0, attributedText.string.utf16.count))
        messageTextView.attributedText = attributedText

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
                self?.messageTextView.text = ""
                completion?()
            }
        } else {
            superview?.layoutIfNeeded()
            messageTextView.text = ""
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

    @objc func dismissButtonTapped(_ sender: UIButton) {
        delegate?.broadcastViewDismissButtonTapped(self)
    }
}

extension BroadcastView: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.broadcastView(self, didTapURL: URL)
        return false
    }
}
