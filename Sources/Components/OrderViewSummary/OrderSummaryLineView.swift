//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class OrderSummaryLineView: UIView {
    // MARK: Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .left
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .right
        return label
    }()

    // MARK: Initalizer

    public init(title: String, price: String, withAutoLayout: Bool = false) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        titleLabel.text = title
        priceLabel.text = price

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods

private extension OrderSummaryLineView {
    func setup() {
        addSubview(titleLabel)
        addSubview(priceLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor),

            priceLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
        ])
    }
}
