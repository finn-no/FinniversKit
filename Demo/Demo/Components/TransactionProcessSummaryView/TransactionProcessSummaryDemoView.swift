//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public class TransactionProcessSummaryDemoView: UIView {
    lazy var transactionProcessSummaryView: TransactionProcessSummaryView = {
        let view = TransactionProcessSummaryView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = TransactionProcessSummaryViewModel(
        title: "Salgsprosess",
        detail: "Kontrakt",
        description: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt",
        externalView: .init(url: "https://www.finn.no/minekjoretoy", text: "Mine kjøretøy"),
        style: "ERROR"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
}

private extension TransactionProcessSummaryDemoView {
    func setup() {
        addSubview(transactionProcessSummaryView)

        NSLayoutConstraint.activate([
            transactionProcessSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionProcessSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])

        transactionProcessSummaryView.configure(with: model, shouldShowExternalView: true)
    }
}

extension TransactionProcessSummaryDemoView: TransactionProcessSummaryViewDelegate {
    public func transactionProcessSummaryViewWasTapped(_ view: TransactionProcessSummaryView) {
        print("Did tap summary view")
    }

    public func transactionProcessExternalViewWasTapped(_ view: TransactionProcessSummaryView) {
        print("Did tap external view")
    }
}
