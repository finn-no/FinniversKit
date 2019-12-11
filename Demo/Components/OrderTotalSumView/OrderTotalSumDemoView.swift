//
//  Created by Saleh-Jan, Robin on 10/12/2019.
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class OrderTotalSumDemoView: UIView {
    private lazy var orderTotalSumView = OrderTotalSumView(title: "Totalsum", totalSum: "1197 Kr", withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(orderTotalSumView)
        orderTotalSumView.fillInSuperview()
    }
}
