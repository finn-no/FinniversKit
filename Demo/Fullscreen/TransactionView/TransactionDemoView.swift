//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

final class TransactionDemoView: UIView {
    private lazy var transactionView: TransactionView = {
        let view = TransactionView(title: "Salgsprosess", numberOfSteps: 8, currentStep: 2, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(transactionView)
        transactionView.fillInSuperview()
    }
}

extension TransactionDemoView: TransactionViewDelegate {
    public func transactionViewDidSelectActionButton(_ view: TransactionView, inStep step: Int) {
        print("Did tap button in step: \(step)")
    }
}
