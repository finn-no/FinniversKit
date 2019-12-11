//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class OrderSummaryView: UIView {
    // MARK: Public properties

    public let height: CGFloat

    // MARK: Private properties

    private lazy var summaryView: UIStackView = {
        let summaryView = UIStackView(withAutoLayout: true)
        summaryView.axis = .vertical
        return summaryView
    }()

    private let model: OrderSummaryViewModel
    private let orderLineViewHeight: CGFloat = 32

    // MARK: Initalizer

    public init(model: OrderSummaryViewModel, withAutoLayout: Bool = false) {
        self.model = model
        self.height = CGFloat(model.orderLines.count * Int(orderLineViewHeight) + 16)

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgTertiary
        clipsToBounds = true

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods

private extension OrderSummaryView {
    func setup() {
        for line in model.orderLines {
            let orderLine = OrderSummaryLineView(title: line.title, price: line.price, withAutoLayout: true)
            summaryView.setCustomSpacing(.mediumSpacing, after: orderLine)

            summaryView.addArrangedSubview(orderLine)
            summaryView.addConstraint(orderLine.heightAnchor.constraint(equalToConstant: orderLineViewHeight))
        }

        addSubview(summaryView)
        NSLayoutConstraint.activate([
            summaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
        ])
    }
}
