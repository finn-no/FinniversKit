//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import UIKit

public protocol BroadcastDelegate: class {
    func broadcastDismissButtonTapped(_ broadcast: BroadcastItem)
    func broadcast(_ broadcast: BroadcastItem, didTapURL url: URL)
}

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast
// MARK: - Public
public final class BroadcastItem: UIView {

    // MARK: Private Properties
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
        textView.linkTextAttributes = BroadcastItem.Style.linkTextAttributes
        return textView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .important))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: .remove), for: .normal)
        button.tintColor = .stone
        button.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Public Properties
    public weak var delegate: BroadcastDelegate?

    /// The message displayed in the presented Broadcast
    /// This property will be nil if not in presenting state
    public var message: String {
        return messageTextView.text
    }

    /// The attributed message displayed in the presented Broadcast
    /// This property will be nil if not in presenting state
    public var attributedMessage: NSAttributedString? {
        return messageTextView.attributedText
    }

    public var model: BroadcastModel? {
        didSet {
            guard let model = model else { return }
            let attributedString = NSMutableAttributedString(attributedString: model.messageWithHTMLLinksReplacedByAttributedStrings)
            attributedString.addAttributes(BroadcastItem.Style.fontAttributes, range: NSMakeRange(0, attributedString.string.utf16.count))
            messageTextView.attributedText = attributedString
        }
    }

    // MARK: - Setup
    public override init(frame: CGRect) {
        super.init(frame: frame)
        isAccessibilityElement = true
        clipsToBounds = true
        layer.cornerRadius = Style.containerCornerRadius
        backgroundColor = Style.backgroundColor
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Init not implemented")
    }
}

// MARK: - Private

extension BroadcastItem {
    private func setupSubviews() {
        addSubview(messageTextView)
        addSubview(iconImageView)
        addSubview(dismissButton)

        let topConstraint = messageTextView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing)
        topConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([

            messageTextView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .smallSpacing),
            messageTextView.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -.smallSpacing),
            topConstraint,

            iconImageView.topAnchor.constraint(equalTo: messageTextView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),

            dismissButton.topAnchor.constraint(equalTo: messageTextView.topAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),

            bottomAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: .mediumLargeSpacing)
            ])
    }

    // MARK: - Actions
    @objc func dismissButtonTapped(_ sender: UIButton) {
        delegate?.broadcastDismissButtonTapped(self)
    }
}

extension BroadcastItem: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.broadcast(self, didTapURL: URL)
        return false
    }
}
