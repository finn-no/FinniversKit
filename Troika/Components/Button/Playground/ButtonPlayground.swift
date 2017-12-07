//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class ButtonPlayground: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let normalButton = Button(style: .default)
        let flatButton = Button(style: .callToAction)
        let destructiveButton = Button(style: .destructive)
        let linkButton = Button(style: .link)

        let button1 = Button(style: .callToAction)
        let button2 = Button(style: .default)

        let disabledNormalButton = Button(style: .default)
        let disabledFlatButton = Button(style: .callToAction)
        let disabledDestructiveButton = Button(style: .destructive)
        let disabledLinkButton = Button(style: .link)

        normalButton.setTitle("Default button", for: .normal)
        flatButton.setTitle("Flat button", for: .normal)
        destructiveButton.setTitle("Destructive button", for: .normal)
        linkButton.setTitle("Link button", for: .normal)

        button1.setTitle("Left button", for: .normal)
        button2.setTitle("Right button", for: .normal)

        disabledNormalButton.setTitle("Disabled default button", for: .normal)
        disabledFlatButton.setTitle("Disabled flat button", for: .normal)
        disabledDestructiveButton.setTitle("Disabled destructive button", for: .normal)
        disabledLinkButton.setTitle("Disabled link button", for: .normal)

        disabledNormalButton.isEnabled = false
        disabledFlatButton.isEnabled = false
        disabledDestructiveButton.isEnabled = false
        disabledLinkButton.isEnabled = false

        normalButton.translatesAutoresizingMaskIntoConstraints = false
        flatButton.translatesAutoresizingMaskIntoConstraints = false
        destructiveButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.translatesAutoresizingMaskIntoConstraints = false

        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false

        disabledNormalButton.translatesAutoresizingMaskIntoConstraints = false
        disabledFlatButton.translatesAutoresizingMaskIntoConstraints = false
        disabledDestructiveButton.translatesAutoresizingMaskIntoConstraints = false
        disabledLinkButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(normalButton)
        addSubview(flatButton)
        addSubview(destructiveButton)
        addSubview(linkButton)

        addSubview(button1)
        addSubview(button2)

        addSubview(disabledNormalButton)
        addSubview(disabledFlatButton)
        addSubview(disabledDestructiveButton)
        addSubview(disabledLinkButton)

        NSLayoutConstraint.activate([
            normalButton.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            normalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            normalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            flatButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .largeSpacing),
            flatButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            flatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            destructiveButton.topAnchor.constraint(equalTo: flatButton.bottomAnchor, constant: .largeSpacing),
            destructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            destructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            linkButton.topAnchor.constraint(equalTo: destructiveButton.bottomAnchor, constant: .largeSpacing),
            linkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            linkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            button1.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .largeSpacing),
            button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            button1.trailingAnchor.constraint(lessThanOrEqualTo: button2.leadingAnchor),

            button2.topAnchor.constraint(equalTo: button1.topAnchor),
            button2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledNormalButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: .largeSpacing),
            disabledNormalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledNormalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledFlatButton.topAnchor.constraint(equalTo: disabledNormalButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledFlatButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledFlatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledDestructiveButton.topAnchor.constraint(equalTo: disabledFlatButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledDestructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledDestructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledLinkButton.topAnchor.constraint(equalTo: disabledDestructiveButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledLinkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledLinkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }
}
