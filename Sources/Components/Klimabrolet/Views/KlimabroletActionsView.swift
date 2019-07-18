//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

class KlimabroletActionsView: UIView {
    // MARK: - Private subviews
    private(set) lazy var primaryButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        return button
    }()

    private(set) lazy var secondaryButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
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
}
