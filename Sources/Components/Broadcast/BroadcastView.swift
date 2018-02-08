//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// Broadcast messages appears without any action from the user.
/// They are used when it´s important to inform the user about something that has affected the whole system and many users.
/// Especially if it has a consequence for how he or she uses the service.
/// https://schibsted.frontify.com/d/oCLrx0cypXJM/design-system#/components/broadcast
public class BroadcastView: UIView {
    let message: String

    lazy var messageLabel: Label = {
        let label = Label(style: Style.labelStyle)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    lazy var iconImage: UIImage? = {
        let image = UIImage(frameworkImageNamed: Style.iconImageAssetName)

        return image
    }()

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public override init(frame: CGRect) {
        message = ""
        super.init(frame: frame)
        setup()
    }

    public init(message: String) {
        self.message = message
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        message = ""
        super.init(coder: aDecoder)
        setup()
    }
}

// MARK: - View setup

private extension BroadcastView {
    func setup() {
        isAccessibilityElement = true
        backgroundColor = Style.backgroundColor
        layer.cornerRadius = Style.containerCornerRadius

        messageLabel.text = message
        iconImageView.image = iconImage

        addSubview(messageLabel)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumLargeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
