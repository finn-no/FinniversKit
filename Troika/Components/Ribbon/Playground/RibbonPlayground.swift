//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class RibbonPlayground: UIView, Injectable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public func setup() {
        backgroundColor = .white

        let successRibbonView = RibbonView()
        let errorRibbonView = RibbonView()
        let warningRibbonView = RibbonView()
        let defaultRibbonView = RibbonView()
        let disabledRibbonView = RibbonView()
        let sponsoredRibbonView = RibbonView()

        let interimSpacing: CGFloat = 16
        let lineSpacing: CGFloat = 8
        let margin: CGFloat = 16

        backgroundColor = .white
        frame = ScreenSize.medium

        successRibbonView.model = RibbonDataModel.success
        errorRibbonView.model = RibbonDataModel.error
        warningRibbonView.model = RibbonDataModel.warning
        defaultRibbonView.model = RibbonDataModel.ordinary
        disabledRibbonView.model = RibbonDataModel.disabled
        sponsoredRibbonView.model = RibbonDataModel.sponsored

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
