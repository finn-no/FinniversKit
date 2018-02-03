//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class RibbonDemo: UIView {

    public lazy var headerLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Status ribbon"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let successRibbonView = RibbonView(style: .success)
        let errorRibbonView = RibbonView(style: .error)
        let warningRibbonView = RibbonView(style: .warning)
        let defaultRibbonView = RibbonView(style: .default, with: "Default")
        let disabledRibbonView = RibbonView(style: .disabled, with: "Disabled")
        let sponsoredRibbonView = RibbonView(style: .sponsored, with: "Sponsored")

        let interimSpacing: CGFloat = 16
        let lineSpacing: CGFloat = 8
        let margin: CGFloat = 16

        successRibbonView.title = "Success"
        errorRibbonView.title = "Error"
        warningRibbonView.title = "Warning"

        defaultRibbonView.translatesAutoresizingMaskIntoConstraints = false
        successRibbonView.translatesAutoresizingMaskIntoConstraints = false
        warningRibbonView.translatesAutoresizingMaskIntoConstraints = false
        errorRibbonView.translatesAutoresizingMaskIntoConstraints = false
        disabledRibbonView.translatesAutoresizingMaskIntoConstraints = false
        sponsoredRibbonView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(headerLabel)
        addSubview(successRibbonView)
        addSubview(errorRibbonView)
        addSubview(warningRibbonView)
        addSubview(defaultRibbonView)
        addSubview(disabledRibbonView)
        addSubview(sponsoredRibbonView)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin),

            defaultRibbonView.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            defaultRibbonView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: margin),

            successRibbonView.leadingAnchor.constraint(equalTo: defaultRibbonView.trailingAnchor, constant: interimSpacing),
            successRibbonView.topAnchor.constraint(equalTo: defaultRibbonView.topAnchor),

            warningRibbonView.leadingAnchor.constraint(equalTo: successRibbonView.trailingAnchor, constant: interimSpacing),
            warningRibbonView.topAnchor.constraint(equalTo: successRibbonView.topAnchor),

            errorRibbonView.leadingAnchor.constraint(equalTo: warningRibbonView.trailingAnchor, constant: interimSpacing),
            errorRibbonView.topAnchor.constraint(equalTo: warningRibbonView.topAnchor),

            disabledRibbonView.leadingAnchor.constraint(equalTo: defaultRibbonView.leadingAnchor),
            disabledRibbonView.topAnchor.constraint(equalTo: defaultRibbonView.bottomAnchor, constant: lineSpacing),

            sponsoredRibbonView.leadingAnchor.constraint(equalTo: disabledRibbonView.trailingAnchor, constant: interimSpacing),
            sponsoredRibbonView.topAnchor.constraint(equalTo: disabledRibbonView.topAnchor),
        ])
    }
}
