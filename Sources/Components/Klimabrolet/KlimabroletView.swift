//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class KlimabroletView: UIView {
    // MARK: - Public properties
    public var model: KlimabroletViewModel? {
        didSet {
            contentView.titleLabel.text = model?.title
            contentView.subtitleTagView.titleLabel.text = model?.subtitle
            contentView.bodyTextLabel.text = model?.bodyText
            contentView.accessoryButton.setTitle(model?.readMoreButtonTitle, for: .normal)
            actionsView.primaryButton.setTitle(model?.acceptButtonTitle, for: .normal)
            actionsView.secondaryButton.setTitle(model?.declineButtonTitle, for: .normal)
        }
    }

    // MARK: - Private properties

    private(set) lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .milk
        button.setImage(UIImage(named: .newClose), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.contentEdgeInsets = UIEdgeInsets(all: 6)

        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.bounces = false
        scrollView.contentInset = UIEdgeInsets(bottom: .largeSpacing)
        return scrollView
    }()

    private lazy var contentView: KlimabroletContentView = {
        let view = KlimabroletContentView(withAutoLayout: true)
        return view
    }()

    private lazy var actionsView = KlimabroletActionsView(withAutoLayout: true)

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2.0
    }

    // MARK: - Private methods
    private func setup() {
        backgroundColor = .milk
        layoutMargins = UIEdgeInsets(all: .mediumLargeSpacing)
        layer.cornerRadius = 20
        clipsToBounds = true

        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])

        addSubview(scrollView)
        addSubview(actionsView)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionsView.topAnchor),

            actionsView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            actionsView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            actionsView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
