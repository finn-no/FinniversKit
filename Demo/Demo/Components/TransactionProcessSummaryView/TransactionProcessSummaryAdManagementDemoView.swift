//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class TransactionProcessSummaryAdManagementDemoView: UIView {
    lazy var transactionProcessSummaryView: TransactionProcessSummaryAdManagementView = {
        let view = TransactionProcessSummaryAdManagementView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = TransactionProcessSummaryViewModel(
        title: "Salgsprosess",
        detail: "Betaling og eierskifte",
        description: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt",
        externalView: .init(text: "Mine kjøretøy", url: "https://www.finn.no/minekjoretoy"),
        style: "ERROR"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
}

private extension TransactionProcessSummaryAdManagementDemoView {
    func setup() {
        addSubview(transactionProcessSummaryView)

        NSLayoutConstraint.activate([
            transactionProcessSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionProcessSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])

        transactionProcessSummaryView.configure(with: model, shouldShowExternalView: true)
    }
}

extension TransactionProcessSummaryAdManagementDemoView: TransactionProcessSummaryAdManagementViewDelegate {
    public func transactionProcessSummaryViewWasTapped(_ view: TransactionProcessSummaryAdManagementView) {
        print("Did tap summary view")
    }

    public func transactionProcessExternalViewWasTapped(_ view: TransactionProcessSummaryAdManagementView) {
        print("Did tap external view")
    }
}
