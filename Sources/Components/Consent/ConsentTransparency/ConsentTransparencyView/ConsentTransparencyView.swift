//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ConsentTransparencyViewDelegate: AnyObject {
    func consentTransparencyView(_ consentTransparencyView: ConsentTransparencyView, didSelectMore button: Button)
    func consentTransparencyView(_ consentTransparencyView: ConsentTransparencyView, didSelectOkay button: Button)
}

public final class ConsentTransparencyView: UIView {

    // MARK: - Internal properties

    private let topImage = UIImage(named: .consentTransparencyImage)

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = topImage
        return imageView
    }()

    private lazy var headerLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()

    private lazy var moreButton: Button = {
        let button = Button(style: .flat)
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var okayButton: Button = {
        let button = Button(style: .callToAction)
        button.addTarget(self, action: #selector(okayButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [moreButton, okayButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = .mediumLargeSpacing
        view.distribution = .fillEqually
        return view
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: ConsentTransparencyViewDelegate?

    public var headerText: String = "" {
        didSet {
            headerLabel.text = headerText
        }
    }

    public var detailText: String = "" {
        didSet {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attributedString = NSMutableAttributedString(string: detailText)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            detailLabel.attributedText = attributedString
        }
    }

    public var moreButtonTitle: String = "" {
        didSet {
            moreButton.setTitle(moreButtonTitle, for: .normal)
        }
    }

    public var okayButtonTitle: String = "" {
        didSet {
            okayButton.setTitle(okayButtonTitle, for: .normal)
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - Private

private extension ConsentTransparencyView {
    func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(detailLabel)
        addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            headerLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            detailLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .mediumSpacing),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.smallSpacing),

            buttonStackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: .mediumLargeSpacing),
            buttonStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: .mediumLargeSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    @objc func moreButtonTapped(_ sender: Button) {
        delegate?.consentTransparencyView(self, didSelectMore: sender)
    }

    @objc func okayButtonTapped(_ sender: Button) {
        delegate?.consentTransparencyView(self, didSelectOkay: sender)
    }
}
