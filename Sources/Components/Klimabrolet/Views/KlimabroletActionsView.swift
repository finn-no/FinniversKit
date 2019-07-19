//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol KlimabroletActionsViewDelegate: AnyObject {
    func klimabroletViewDidSelectPrimaryButton(_ view: KlimabroletActionsView)
    func klimabroletViewDidSelectSecondaryButton(_ view: KlimabroletActionsView)
}

class KlimabroletActionsView: UIView {
    weak var delegate: KlimabroletActionsViewDelegate?

    // MARK: - Private subviews

    private(set) lazy var primaryButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(handleTapOnPrimaryButton), for: .touchUpInside)
        return button
    }()

    private(set) lazy var secondaryButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTapOnSecondaryButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal methods

    func configure(primaryButtonTitle: String, secondaryButtonTitle: String) {
        primaryButton.setTitle(primaryButtonTitle, for: .normal)
        secondaryButton.setTitle(secondaryButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    private func setup() {
        layoutMargins = UIEdgeInsets(
            top: .mediumSpacing,
            leading: .mediumLargeSpacing,
            bottom: .mediumLargeSpacing,
            trailing: .mediumLargeSpacing
        )
        backgroundColor = .milk

        addSubview(primaryButton)
        addSubview(secondaryButton)

        NSLayoutConstraint.activate([
            primaryButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            primaryButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor),
            secondaryButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            secondaryButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }

    @objc private func handleTapOnPrimaryButton() {
        delegate?.klimabroletViewDidSelectPrimaryButton(self)
    }

    @objc private func handleTapOnSecondaryButton() {
        delegate?.klimabroletViewDidSelectSecondaryButton(self)
    }
}
