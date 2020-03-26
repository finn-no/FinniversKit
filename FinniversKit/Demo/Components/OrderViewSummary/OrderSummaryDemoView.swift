//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class OrderSummaryDemoView: UIView {
    private lazy var orderSummaryView = OrderSummaryView(orderLines: OrderSummaryViewRegularDefaultData.orderLines, withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(orderSummaryView)
        NSLayoutConstraint.activate([
            orderSummaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            orderSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingS),
            orderSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingS),
            orderSummaryView.heightAnchor.constraint(equalToConstant: orderSummaryView.height)
        ])
    }
}
