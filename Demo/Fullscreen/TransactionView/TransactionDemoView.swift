//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

final class TransactionDemoView: UIView {
    private lazy var transactionView = TransactionView(title: "Salgsprosess", dataSource: self, delegate: self, withAutoLayout: true)

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

extension TransactionDemoView: TransactionViewDataSource {
    func transactionViewNumberOfSteps(_ view: TransactionView) -> Int {
        return TransactionStepsFactory.numberOfSteps
    }

    func transactionViewCurrentStep(_ view: TransactionView) -> Int {
        let isTransactionCompleted = TransactionStepsFactory.steps.filter({ $0.state != .completed }).count == 0
        let currentStep = TransactionStepsFactory.steps.firstIndex(where: { $0.state == .inProgress }) ?? 0
        let lastStep = TransactionStepsFactory.numberOfSteps
        return isTransactionCompleted ? lastStep : currentStep
    }

    func transactionViewModelForIndex(_ view: TransactionView, forStep step: Int) -> TransactionStepViewModel {
        return TransactionStepsFactory.steps[step]
    }
}
