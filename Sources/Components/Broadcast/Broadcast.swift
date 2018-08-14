//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BroadcastDelegate: class {
    func broadcastDismissButtonTapped(_ broadcast: Broadcast)
    func broadcast(_ broadcast: Broadcast, didTapURL url: URL)
}

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast
public final class Broadcast: UIView {
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
        textView.linkTextAttributes = Broadcast.Style.linkTextAttributes
        return textView
    }()

    private lazy var iconImage: UIImage? = {
        let image = UIImage(named: .important)
        return image
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = iconImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var dismissButtonImage: UIImage? = {
        let image = UIImage(named: .remove)
        return image
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(dismissButtonImage, for: .normal)
        button.tintColor = .stone
        button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    public weak var delegate: BroadcastDelegate?

    /// A property indicating if the Broadcast is in its presenting state
    public private(set) var isPresenting = false

    /// The message displayed in the presented Broadcast
    /// This property will be nil if not in presenting state
    public var message: String? {
        return messageTextView.text
    }

    /// The attributed message displayed in the presented Broadcast
    /// This property will be nil if not in presenting state
    public var attributedMessage: NSAttributedString? {
        return messageTextView.attributedText
    }

    public let model: BroadcastModel

    /// Initalizes a BrodcastView
    public init(model: BroadcastModel) {
        self.model = model
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Init not implemented")
    }
}

// MARK: - Private

private extension Broadcast {
    func setup() {
        isAccessibilityElement = true
        backgroundColor = Style.backgroundColor
        clipsToBounds = true
        layer.cornerRadius = Style.containerCornerRadius

        let attributedText = NSMutableAttributedString(attributedString: model.messageWithHTMLLinksReplacedByAttributedStrings)
        attributedText.addAttributes(Broadcast.Style.fontAttributes, range: NSMakeRange(0, attributedText.string.utf16.count))
        messageTextView.attributedText = attributedText

        addSubview(messageTextView)
        addSubview(iconImageView)
        addSubview(dismissButton)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            dismissButton.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),

            messageTextView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .smallSpacing),
            messageTextView.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -.smallSpacing),
            messageTextView.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            messageTextView.heightAnchor.constraint(greaterThanOrEqualTo: iconImageView.heightAnchor),

            bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: .mediumLargeSpacing)
        ])
    }


    @objc func dismissButtonTapped(_ sender: UIButton) {
        delegate?.broadcastDismissButtonTapped(self)
    }
}

extension Broadcast: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.broadcast(self, didTapURL: URL)
        return false
    }
}
