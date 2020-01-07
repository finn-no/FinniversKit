//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class PaymentOptionsListViewDemoView: UIView {
    private var items = PaymentOptionsListDemoViewHelpers.items

    private lazy var vippsSummaryView = OrderSummaryView(orderLines: PaymentOptionsListDemoViewHelpers.vippsOrderLines, withAutoLayout: true)
    private lazy var paymentCardSummaryView = OrderSummaryView(orderLines: PaymentOptionsListDemoViewHelpers.paymentCardOrderLines, withAutoLayout: true)
    private lazy var smsSummaryView = OrderSummaryView(orderLines: PaymentOptionsListDemoViewHelpers.smsOrderLines, withAutoLayout: true)
    private lazy var invoiceSummaryView = OrderSummaryView(orderLines: PaymentOptionsListDemoViewHelpers.invoiceOrderLines, withAutoLayout: true)

    private lazy var paymentOptionsListView: PaymentOptionsListView = {
        let view = PaymentOptionsListView(items: items, totalSumViewTitle: "Totalsum",
                                          collapseViewTitle: "Vis oppsummering", collapseViewExpandedTitle: "Skjul oppsummering")
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }
}

private extension PaymentOptionsListViewDemoView {
    func setup() {
        addSubview(paymentOptionsListView)
        paymentOptionsListView.fillInSuperview()

        guard let model = items.first else { return }
        paymentOptionsListView.updateFooterButtonTitle("Betal med \(model.title)")
        paymentOptionsListView.updateTotalSumValue("1234 Kr")
        paymentOptionsListView.collapseViewReplacePresentedView(vippsSummaryView, vippsSummaryView.height)
    }
}

extension PaymentOptionsListViewDemoView: PaymentOptionsListViewDelegate {
    public func paymentOptionsListView(_ view: PaymentOptionsListView, didSelectRowAt indexPath: IndexPath) {
        guard let model = items[safe: indexPath.row] else { return }
        view.updateFooterButtonTitle("Betal med \(model.title.lowercased())")
        view.updateTotalSumValue("\(Int(arc4random_uniform(10000))) Kr")

        switch indexPath.row {
        case 0:
            view.collapseViewReplacePresentedView(vippsSummaryView, vippsSummaryView.height)
        case 1:
            view.collapseViewReplacePresentedView(paymentCardSummaryView, paymentCardSummaryView.height)
        case 2:
            view.collapseViewReplacePresentedView(smsSummaryView, smsSummaryView.height)
        case 3:
            view.collapseViewReplacePresentedView(invoiceSummaryView, invoiceSummaryView.height)
        default: return
        }
    }

    public func paymentOptionsListView(_ view: PaymentOptionsListView, didSelectButton button: UIButton) {
        print("Did tap button")
    }
}
