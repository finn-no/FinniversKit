//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public enum PushNotificationDetails {
    case savedSearch(text: String, title: String)
    case priceChange(text: String, value: String)
}

class PushNotificationDetailsView: UIControl {

    // MARK: - Private properties

    private lazy var magnifyingIconView: UIImageView = {
        let image = UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textPrimary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return imageView
    }()

    private lazy var textLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var arrowIconView: UIImageView = {
        let image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textAction
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var timestampLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private var highlightedRange: NSRange?
    private var attributedString: NSMutableAttributedString?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override var isHighlighted: Bool {
        didSet {
            guard !isHighlighted, oldValue else { return }
            guard let range = highlightedRange else { return }
            arrowIconView.tintColor = .textAction
            attributedString?.removeAttribute(.underlineStyle, range: range)
            attributedString?.addAttribute(.foregroundColor, value: UIColor.textAction, range: range)
            textLabel.attributedText = attributedString
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard super.beginTracking(touch, with: event) else { return false }
        guard let range = highlightedRange else { return false }
        arrowIconView.tintColor = .linkButtonHighlightedTextColor
        attributedString?.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString?.addAttribute(.foregroundColor, value: UIColor.linkButtonHighlightedTextColor, range: range)
        textLabel.attributedText = attributedString
        return true
    }

    // MARK: - Internal methods

    func configure(with details: PushNotificationDetails?, timestamp: String?) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.caption,
            .foregroundColor: UIColor.textPrimary
        ]

        switch details {
        case let .savedSearch(text, title):
            magnifyingIconView.isHidden = false
            arrowIconView.isHidden = false

            let textRange = NSRange(location: 0, length: text.count + 1)
            highlightedRange = NSRange(location: text.count + 1, length: title.count)

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.captionStrong,
                .foregroundColor: UIColor.textAction
            ]

            attributedString = NSMutableAttributedString(string: text + " " + title)
            attributedString?.setAttributes(textAttributes, range: textRange)
            attributedString?.setAttributes(titleAttributes, range: highlightedRange!)

        case let .priceChange(text, value):
            magnifyingIconView.isHidden = true
            arrowIconView.isHidden = true

            let textRange = NSRange(location: 0, length: text.count + 1)
            let valueRange = NSRange(location: text.count + 1, length: value.count)

            let valueAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.captionStrong,
                .foregroundColor: UIColor.textPrimary
            ]

            attributedString = NSMutableAttributedString(string: text + " " + value)
            attributedString?.setAttributes(textAttributes, range: textRange)
            attributedString?.setAttributes(valueAttributes, range: valueRange)

        case .none:
            highlightedRange = nil
            attributedString = nil
        }

        timestampLabel.text = timestamp
        textLabel.attributedText = attributedString
    }

    // MARK: - Private methods

    private func setup() {
        stackView.addArrangedSubview(magnifyingIconView)
        stackView.addArrangedSubview(textLabel)
        stackView.addArrangedSubview(arrowIconView)
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(timestampLabel)
        stackView.setCustomSpacing(.smallSpacing, after: magnifyingIconView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
