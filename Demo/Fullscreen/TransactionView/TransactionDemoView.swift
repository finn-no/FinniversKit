//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

final class TransactionDemoView: UIView {
    private lazy var dataSource = TransactionDemoViewDefaultData()
    private lazy var model: TransactionViewModel = dataSource.getState()
    private var transactionView: TransactionView?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        if transactionView != nil {
            transactionView?.removeFromSuperview()
        }

        model = dataSource.getState()
        transactionView = TransactionView(withAutoLayout: true, model: model, dataSource: self, delegate: self)

        addSubview(transactionView!)
        transactionView!.fillInSuperview()
    }
}

// MARK: TransactionViewDelegate

extension TransactionDemoView: TransactionViewDelegate {
    func transactionViewDidBeginRefreshing(_ refreshControl: RefreshControl) {
        print("Did pull to refresh will update with new state")
        configure()
        refreshControl.endRefreshing()
    }

    func transactionViewDidTapActionButton(_ view: TransactionView,
                                           inTransactionStep step: Int,
                                           withAction action: TransactionStepView.ActionButton.Action,
                                           withUrl urlString: String?,
                                           withFallbackUrl fallbackUrlString: String?) {

        print("Did tap button in step: \(step), with action: \(action.rawValue), with urlString: \(urlString ?? ""), with fallbackUrl:\(fallbackUrlString ?? "")")
    }
}

// MARK: TransactionViewDataSource

extension TransactionDemoView: TransactionViewDataSource {
    func transactionView(_ view: TransactionView, loadImageWithUrl url: URL, completion: @escaping ((UIImage?) -> Void)) {

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func transactionView(_ view: TransactionView, cancelLoadingImageWithUrl url: URL) {}

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
