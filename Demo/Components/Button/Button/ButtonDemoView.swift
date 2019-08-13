//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ButtonDemoView: UIView, UserInterfaceUpdatable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    var normalButton: Button!
    var smallNormalButton: Button!

    var callToActionButton: Button!
    var destructiveButton: Button!
    var flatButton: Button!
    var linkButton: Button!

    var button1: Button!
    var button2: Button!

    var disabledNormalButton: Button!
    var disabledCallToActionButton: Button!
    var disabledDestructiveButton: Button!
    var disabledFlatButton: Button!
    var disabledLinkButton: Button!

    private func setup() {
        normalButton = Button(style: .default)
        smallNormalButton = Button(style: .default, size: .small)

        callToActionButton = Button(style: .callToAction)
        destructiveButton = Button(style: .destructive)
        flatButton = Button(style: .flat)
        linkButton = Button(style: .link)

        button1 = Button(style: .callToAction)
        button2 = Button(style: .default)

        disabledNormalButton = Button(style: .default)
        disabledCallToActionButton = Button(style: .callToAction)
        disabledDestructiveButton = Button(style: .destructive)
        disabledFlatButton = Button(style: .flat)
        disabledLinkButton = Button(style: .link)

        normalButton.setTitle("Default button", for: .normal)
        smallNormalButton.setTitle("Small default button", for: .normal)

        callToActionButton.setTitle("Call to action button", for: .normal)
        destructiveButton.setTitle("Destructive button", for: .normal)

        flatButton.setTitle("Flat button", for: .normal)
        linkButton.setTitle("Link button", for: .normal)

        button1.setTitle("Left button", for: .normal)
        button2.setTitle("Right button", for: .normal)

        disabledNormalButton.setTitle("Disabled default button", for: .normal)
        disabledCallToActionButton.setTitle("Disabled call to action button", for: .normal)
        disabledDestructiveButton.setTitle("Disabled destructive button", for: .normal)
        disabledFlatButton.setTitle("Disabled flat button", for: .normal)
        disabledLinkButton.setTitle("Disabled link button", for: .normal)

        disabledNormalButton.isEnabled = false
        disabledCallToActionButton.isEnabled = false
        disabledDestructiveButton.isEnabled = false
        disabledFlatButton.isEnabled = false
        disabledLinkButton.isEnabled = false

        normalButton.translatesAutoresizingMaskIntoConstraints = false
        smallNormalButton.translatesAutoresizingMaskIntoConstraints = false

        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        destructiveButton.translatesAutoresizingMaskIntoConstraints = false

        flatButton.translatesAutoresizingMaskIntoConstraints = false
        linkButton.translatesAutoresizingMaskIntoConstraints = false

        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false

        disabledNormalButton.translatesAutoresizingMaskIntoConstraints = false
        disabledCallToActionButton.translatesAutoresizingMaskIntoConstraints = false
        disabledDestructiveButton.translatesAutoresizingMaskIntoConstraints = false
        disabledFlatButton.translatesAutoresizingMaskIntoConstraints = false
        disabledLinkButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(normalButton)
        addSubview(smallNormalButton)

        addSubview(callToActionButton)
        addSubview(destructiveButton)

        addSubview(flatButton)
        addSubview(linkButton)

        addSubview(button1)
        addSubview(button2)

        addSubview(disabledNormalButton)
        addSubview(disabledCallToActionButton)
        addSubview(disabledDestructiveButton)
        addSubview(disabledFlatButton)
        addSubview(disabledLinkButton)

        NSLayoutConstraint.activate([
            normalButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            normalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            normalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            smallNormalButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .mediumLargeSpacing),
            smallNormalButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            callToActionButton.topAnchor.constraint(equalTo: smallNormalButton.bottomAnchor, constant: .mediumLargeSpacing),
            callToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            destructiveButton.topAnchor.constraint(equalTo: callToActionButton.bottomAnchor, constant: .mediumLargeSpacing),
            destructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            destructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            flatButton.topAnchor.constraint(equalTo: destructiveButton.bottomAnchor, constant: .mediumLargeSpacing),
            flatButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            linkButton.topAnchor.constraint(equalTo: flatButton.bottomAnchor, constant: .mediumLargeSpacing),
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            button1.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .mediumLargeSpacing),
            button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            button1.trailingAnchor.constraint(lessThanOrEqualTo: button2.leadingAnchor),

            button2.topAnchor.constraint(equalTo: button1.topAnchor),
            button2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledNormalButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: .mediumLargeSpacing),
            disabledNormalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledNormalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledCallToActionButton.topAnchor.constraint(equalTo: disabledNormalButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledCallToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledCallToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledDestructiveButton.topAnchor.constraint(equalTo: disabledCallToActionButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledDestructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            disabledDestructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            disabledFlatButton.topAnchor.constraint(equalTo: disabledDestructiveButton.bottomAnchor, constant: .mediumLargeSpacing),
            disabledFlatButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            disabledLinkButton.topAnchor.constraint(equalTo: disabledFlatButton.bottomAnchor, constant: .mediumSpacing),
            disabledLinkButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    public func updateColors() {
        let userInterfaceStyle = UserInterfaceStyle(traitCollection: traitCollection)
        backgroundColor = userInterfaceStyle.foregroundColor

        normalButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        smallNormalButton.updateColors(userInterfaceStyle: userInterfaceStyle)

        callToActionButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        destructiveButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        flatButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        linkButton.updateColors(userInterfaceStyle: userInterfaceStyle)

        button1.updateColors(userInterfaceStyle: userInterfaceStyle)
        button2.updateColors(userInterfaceStyle: userInterfaceStyle)

        disabledNormalButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        disabledCallToActionButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        disabledDestructiveButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        disabledFlatButton.updateColors(userInterfaceStyle: userInterfaceStyle)
        disabledLinkButton.updateColors(userInterfaceStyle: userInterfaceStyle)
    }
}
