//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class EarthHourSignUpView: EarthHourContentView {
    private(set) lazy var subtitleTagView = EarthHourTagView(withAutoLayout: true)

    private(set) lazy var primaryButton: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private(set) lazy var secondaryButton: UIButton = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    override func setup() {
        backgroundColor = .bgPrimary

        addSubview(titleLabel)
        addSubview(subtitleTagView)
        addSubview(bodyTextLabel)
        addSubview(primaryButton)
        addSubview(secondaryButton)
        addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing + .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            subtitleTagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            subtitleTagView.centerXAnchor.constraint(equalTo: centerXAnchor),

            bodyTextLabel.topAnchor.constraint(equalTo: subtitleTagView.bottomAnchor, constant: .smallSpacing * 3),
            bodyTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyTextLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),

            accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: .mediumSpacing),
            accessoryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            primaryButton.topAnchor.constraint(equalTo: accessoryButton.bottomAnchor, constant: .smallSpacing * 3),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            primaryButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: .smallSpacing * 3),
            secondaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            secondaryButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.smallSpacing * 4)
        ])
    }
}
