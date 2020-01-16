//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public struct SavedSearchLinkViewModel {
    public let text: String
    public let title: String
    public let timestamp: String

    public init(text: String, title: String, timestamp: String) {
        self.text = text
        self.title = title
        self.timestamp = timestamp
    }
}

class SavedSearchLinkView: UIControl {

    private lazy var magnifyingIconView: UIImageView = {
        let image = UIImage(named: .magnifyingGlass)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textPrimary
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var timestampLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    private var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.caption,
        .foregroundColor: UIColor.textPrimary
    ]

    private var titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.captionStrong,
        .foregroundColor: UIColor.textAction
    ]

    private var highlightedTitleAttributes: [NSAttributedString.Key: Any] = [
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .font: UIFont.captionStrong,
        .foregroundColor: UIColor.textAction
    ]

    private var textRange: NSRange?
    private var titleRange: NSRange?
    private var attributedString: NSMutableAttributedString?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if super.beginTracking(touch, with: event) {
            setTitleAttributes(highlightedTitleAttributes)
            return true
        }

        return false
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        setTitleAttributes(titleAttributes)
        super.endTracking(touch, with: event)
    }

    // MARK: - Internal methods

    func configure(with model: SavedSearchLinkViewModel?) {
        timestampLabel.text = model?.timestamp

        guard let text = model?.text, let title = model?.title else { return }

        textRange = NSRange(location: 0, length: text.count + 1)
        titleRange = NSRange(location: text.count + 1, length: title.count)

        attributedString = NSMutableAttributedString(string: text + " " + title)
        attributedString?.setAttributes(textAttributes, range: textRange!)
        attributedString?.setAttributes(titleAttributes, range: titleRange!)

        textLabel.attributedText = attributedString
    }

    // MARK: - Private methods

    func setTitleAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        guard let titleRange = titleRange else { return }
        attributedString?.setAttributes(attributes, range: titleRange)
        textLabel.attributedText = attributedString
    }

    private func setup() {
        addSubview(magnifyingIconView)
        addSubview(textLabel)
        addSubview(arrowIconView)
        addSubview(timestampLabel)

        NSLayoutConstraint.activate([
            magnifyingIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            magnifyingIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            magnifyingIconView.widthAnchor.constraint(equalToConstant: 14),
            magnifyingIconView.heightAnchor.constraint(equalToConstant: 14),

            textLabel.leadingAnchor.constraint(equalTo: magnifyingIconView.trailingAnchor, constant: .smallSpacing),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            arrowIconView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: .verySmallSpacing),
            arrowIconView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            arrowIconView.widthAnchor.constraint(equalToConstant: 8),
            arrowIconView.heightAnchor.constraint(equalToConstant: 10),

            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            timestampLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
