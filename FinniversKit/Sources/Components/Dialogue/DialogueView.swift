//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

// MARK: - DialogueViewModel

/**
 - Note:
    Use this protocol to update Dialogue view model

 */

public protocol DialogueViewModel {
    var title: String { get }
    var detail: String { get set }
    var link: String { get }
    var primaryButtonTitle: String { get }
}

// MARK: - DialogueViewDelegate

/**
 - Note:
    Protocol to call back the Dialogue view Delegate

 */

public protocol DialogueViewDelegate: AnyObject {
    func dialogueViewDidSelectLink()
    func dialogueViewDidSelectPrimaryButton()
}

// MARK: - DialogueView

/**
 - Note:
 A view ment to be used as a Dialogue view
 Optional image, link and secondary button. 

 */

public class DialogueView: UIView {

    // MARK: - Subviews

    private lazy var title: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detail: UILabel = {
        let label = Label(style: .caption)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var link: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLinkTap), for: .touchUpInside)
        return button
    }()

    private lazy var primaryButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Model

    public var model: DialogueViewModel? {
        didSet {
            title.text = model?.title
            detail.text = model?.detail
            link.setTitle(model?.link, for: .normal)
            primaryButton.setTitle(model?.primaryButtonTitle, for: .normal)
        }
    }

    // MARK: - Delegate

    public weak var delegate: DialogueViewDelegate?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        layer.cornerRadius = 8

        addSubview(title)
        addSubview(detail)
        addSubview(link)
        addSubview(primaryButton)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXL),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            detail.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .spacingS),
            detail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            detail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            primaryButton.topAnchor.constraint(equalTo: detail.bottomAnchor, constant: .spacingM),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            link.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .spacingS),
            link.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            link.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),
        ])
    }

    func heightWithConstrained(width: CGFloat) -> CGFloat {
        guard let text = detail.text else {
            return 0
        }

        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin],
            attributes: [NSAttributedString.Key.font: detail.font ?? .caption], context: nil
        )

        var moreSpacing: CGFloat = 0

        if UIDevice.isSmallScreen() {
            moreSpacing = .spacingXL
        } else if UIDevice.isLandscape() {
            moreSpacing = -.spacingXL - 10
        }

        return boundingBox.height - moreSpacing
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.dialogueViewDidSelectPrimaryButton()
    }

    @objc private func handleLinkTap() {
        delegate?.dialogueViewDidSelectLink()
    }
}
