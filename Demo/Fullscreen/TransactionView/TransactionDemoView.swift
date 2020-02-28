//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

final class TransactionDemoView: UIView {
    private lazy var model = TransactionDemoViewDefaultData.model

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        let transactionView = TransactionView(model: model, dataSource: self, delegate: self, withAutoLayout: true)
        addSubview(transactionView)
        transactionView.fillInSuperview()
    }
}

extension TransactionDemoView: TransactionViewDelegate {
    func transactionViewDidBeginRefreshing(_ refreshControl: RefreshControl) {
        refreshControl.endRefreshing()
    }

    func transactionViewDidSelectPrimaryButton(_ view: TransactionView, inTransactionStep step: Int,
                                               withAction action: TransactionStepView.PrimaryButton.Action, withUrl urlString: String?,
                                               withFallbackUrl fallbackUrlString: String?) {
        print("Did tap button in step: \(step), with action: \(action.rawValue), with urlString: \(urlString ?? ""), with fallbackUrl:\(fallbackUrlString ?? "")")
    }
}

extension TransactionDemoView: TransactionViewDataSource {
    func transactionViewNumberOfSteps(_ view: TransactionView) -> Int {
        return model.steps.count
    }

    func transactionViewCurrentStep(_ view: TransactionView) -> Int {
        let isTransactionCompleted = model.steps.filter({ $0.state != .completed }).count == 0
        let currentStep = model.steps.firstIndex(where: { $0.state == .active }) ?? 0
        let lastStep = model.steps.count
        return isTransactionCompleted ? lastStep : currentStep
    }

    func transactionViewModelForIndex(_ view: TransactionView, forStep step: Int) -> TransactionStepViewModel {
        return model.steps[step]
    }
}
