//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class OrderSummaryDemoView: UIView {
    private lazy var orderSummaryView = OrderSummaryView(model: OrderSummaryViewDefaultData(), withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(orderSummaryView)
        NSLayoutConstraint.activate([
            orderSummaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),
            orderSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            orderSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing),
            orderSummaryView.heightAnchor.constraint(equalToConstant: orderSummaryView.height)
        ])
    }
}
