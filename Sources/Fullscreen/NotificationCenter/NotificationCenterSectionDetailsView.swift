//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public enum NotificationCenterSectionDetails {
    case link(text: String, title: String, showSearchIcon: Bool)
    case `static`(text: String, value: String)
}

class NotificationCenterSectionDetailsView: UIControl {

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

    private lazy var textLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 1
        return label
    }()

    private lazy var textLabelToSuperviewConstraint = textLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor
    )

    private lazy var textLabelToMagnifyingIconConstraint = textLabel.leadingAnchor.constraint(
        equalTo: magnifyingIconView.trailingAnchor,
        constant: .spacingXXS
    )

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
            attributedString?.removeAttribute(.underlineStyle, range: range)
            attributedString?.addAttribute(.foregroundColor, value: UIColor.textAction, range: range)
            textLabel.attributedText = attributedString
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard super.beginTracking(touch, with: event) else { return false }
        guard let range = highlightedRange else { return false }
        attributedString?.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString?.addAttribute(.foregroundColor, value: UIColor.linkButtonHighlightedTextColor, range: range)
        textLabel.attributedText = attributedString
        return true
    }

    // MARK: - Internal methods

    func configure(with details: NotificationCenterSectionDetails?) {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.caption,
            .foregroundColor: UIColor.textPrimary
        ]

        switch details {
        case let .link(text, title, showMagnifyingGlass):
            magnifyingIconView.isHidden = !showMagnifyingGlass

            textLabelToSuperviewConstraint.isActive = magnifyingIconView.isHidden
            textLabelToMagnifyingIconConstraint.isActive = !magnifyingIconView.isHidden

            let textRange = NSRange(location: 0, length: text.count + 1)
            highlightedRange = NSRange(location: text.count + 1, length: title.count)

            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.captionStrong,
                .foregroundColor: UIColor.textAction
            ]

            attributedString = NSMutableAttributedString(string: text + " " + title)
            attributedString?.setAttributes(textAttributes, range: textRange)
            attributedString?.setAttributes(titleAttributes, range: highlightedRange!)

        case let .static(text, value):
            magnifyingIconView.isHidden = true

            textLabelToSuperviewConstraint.isActive = magnifyingIconView.isHidden
            textLabelToMagnifyingIconConstraint.isActive = !magnifyingIconView.isHidden

            highlightedRange = nil
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

        textLabel.attributedText = attributedString
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(magnifyingIconView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 48),

            magnifyingIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            magnifyingIconView.bottomAnchor.constraint(equalTo: textLabel.firstBaselineAnchor, constant: 2),

            textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
        ])
    }
}
