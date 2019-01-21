//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import UIKit

protocol BroadcastItemDelegate: class {
    func broadcastItemDismissButtonTapped(_ broadcastItem: BroadcastItem)
    func broadcastItem(_ broadcastItem: BroadcastItem, didTapURL url: URL)
}

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast

// MARK: - Public

class BroadcastItem: UIView {
    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.layer.cornerRadius = Style.containerCornerRadius
        view.backgroundColor = Style.backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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

    var heightConstraint: NSLayoutConstraint!

    weak var delegate: BroadcastItemDelegate?

    var message: BroadcastMessage

    // MARK: - Setup

    init(message: BroadcastMessage) {
        self.message = message
        super.init(frame: .zero)

        isAccessibilityElement = true
        clipsToBounds = true

        setAttributedText(message)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Init not implemented")
    }
}

// MARK: - Private

extension BroadcastItem {
    private func setupSubviews() {
        contentView.addSubview(messageTextView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(dismissButton)
        addSubview(contentView)

        heightConstraint = heightAnchor.constraint(equalToConstant: 0)

        let topConstraint = contentView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing)
        topConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            topConstraint,
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            messageTextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            messageTextView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .smallSpacing),
            messageTextView.trailingAnchor.constraint(equalTo: dismissButton.leadingAnchor, constant: -.smallSpacing),
            messageTextView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: .mediumLargeSpacing),

            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),

            dismissButton.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: messageTextView.bottomAnchor, constant: .mediumLargeSpacing),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: .mediumLargeSpacing),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setAttributedText(_ message: BroadcastMessage) {
        let attributedString = NSMutableAttributedString(attributedString: message.attributedString(for: message.text))
        attributedString.addAttributes(BroadcastItem.Style.fontAttributes, range: NSRange(location: 0, length: attributedString.string.utf16.count))
        messageTextView.attributedText = attributedString
    }

    // MARK: - Actions

    @objc func dismissButtonTapped(_ sender: UIButton) {
        delegate?.broadcastItemDismissButtonTapped(self)
    }
}

extension BroadcastItem: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        delegate?.broadcastItem(self, didTapURL: URL)
        return false
    }
}
