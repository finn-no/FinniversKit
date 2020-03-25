//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ButtonDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let normalButton = Button(style: .default)
        let smallNormalButton = Button(style: .default, size: .small)

        let utilityButton = Button(style: .utility, size: .small)

        let callToActionButton = Button(style: .callToAction)
        let destructiveButton = Button(style: .destructive)
        let flatButton = Button(style: .flat)
        let destructiveFlatButton = Button(style: .destructiveFlat)
        let linkButton = Button(style: .link)

        let button1 = Button(style: .callToAction)
        let button2 = Button(style: .default)

        let disabledNormalButton = Button(style: .default)
        let disabledCallToActionButton = Button(style: .callToAction)
        let disabledDestructiveButton = Button(style: .destructive)
        let disabledFlatButton = Button(style: .flat)
        let disabledLinkButton = Button(style: .link)

        normalButton.setTitle("Default button", for: .normal)
        smallNormalButton.setTitle("Small default button", for: .normal)

        utilityButton.setTitle("Utility button", for: .normal)

        callToActionButton.setTitle("Call to action button", for: .normal)
        destructiveButton.setTitle("Destructive button", for: .normal)

        flatButton.setTitle("Flat button", for: .normal)
        destructiveFlatButton.setTitle("Destructive Flat button", for: .normal)
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

        utilityButton.translatesAutoresizingMaskIntoConstraints = false

        callToActionButton.translatesAutoresizingMaskIntoConstraints = false
        destructiveButton.translatesAutoresizingMaskIntoConstraints = false

        flatButton.translatesAutoresizingMaskIntoConstraints = false
        destructiveFlatButton.translatesAutoresizingMaskIntoConstraints = false
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

        addSubview(utilityButton)

        addSubview(callToActionButton)
        addSubview(destructiveButton)

        addSubview(flatButton)
        addSubview(destructiveFlatButton)
        addSubview(linkButton)

        addSubview(button1)
        addSubview(button2)

        addSubview(disabledNormalButton)
        addSubview(disabledCallToActionButton)
        addSubview(disabledDestructiveButton)
        addSubview(disabledFlatButton)
        addSubview(disabledLinkButton)

        NSLayoutConstraint.activate([
            normalButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            normalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            normalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            smallNormalButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .spacingM),
            smallNormalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            smallNormalButton.trailingAnchor.constraint(lessThanOrEqualTo: button2.leadingAnchor),

            utilityButton.topAnchor.constraint(equalTo: normalButton.bottomAnchor, constant: .spacingM),
            utilityButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            callToActionButton.topAnchor.constraint(equalTo: smallNormalButton.bottomAnchor, constant: .spacingM),
            callToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            callToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            destructiveButton.topAnchor.constraint(equalTo: callToActionButton.bottomAnchor, constant: .spacingM),
            destructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            destructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            flatButton.topAnchor.constraint(equalTo: destructiveButton.bottomAnchor, constant: .spacingM),
            flatButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            flatButton.trailingAnchor.constraint(lessThanOrEqualTo: button2.leadingAnchor),

            destructiveFlatButton.topAnchor.constraint(equalTo: flatButton.topAnchor),
            destructiveFlatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            linkButton.topAnchor.constraint(equalTo: flatButton.bottomAnchor, constant: .spacingM),
            linkButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            button1.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .spacingM),
            button1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            button1.trailingAnchor.constraint(lessThanOrEqualTo: button2.leadingAnchor),

            button2.topAnchor.constraint(equalTo: button1.topAnchor),
            button2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            disabledNormalButton.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: .spacingM),
            disabledNormalButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            disabledNormalButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            disabledCallToActionButton.topAnchor.constraint(equalTo: disabledNormalButton.bottomAnchor, constant: .spacingM),
            disabledCallToActionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            disabledCallToActionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            disabledDestructiveButton.topAnchor.constraint(equalTo: disabledCallToActionButton.bottomAnchor, constant: .spacingM),
            disabledDestructiveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            disabledDestructiveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            disabledFlatButton.topAnchor.constraint(equalTo: disabledDestructiveButton.bottomAnchor, constant: .spacingM),
            disabledFlatButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            disabledLinkButton.topAnchor.constraint(equalTo: disabledFlatButton.bottomAnchor, constant: .spacingS),
            disabledLinkButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
