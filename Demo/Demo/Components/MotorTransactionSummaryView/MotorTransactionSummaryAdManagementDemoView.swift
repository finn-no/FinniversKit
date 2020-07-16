//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class MotorTransactionSummaryAdManagementDemoView: UIView {
    lazy var transactionProcessSummaryView: MotorTransactionSummaryAdManagementView = {
        let view = MotorTransactionSummaryAdManagementView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = MotorTransactionSummaryViewModel(
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

private extension MotorTransactionSummaryAdManagementDemoView {
    func setup() {
        addSubview(transactionProcessSummaryView)

        NSLayoutConstraint.activate([
            transactionProcessSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionProcessSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])

        transactionProcessSummaryView.configure(with: model, shouldShowExternalView: true)
    }
}

extension MotorTransactionSummaryAdManagementDemoView: MotorTransactionSummaryAdManagementViewDelegate {
    public func motorTransactionSummaryViewWasTapped(_ view: MotorTransactionSummaryAdManagementView) {
        print("Did tap summary view")
    }

    public func motorTransactionSummaryExternalViewWasTapped(_ view: MotorTransactionSummaryAdManagementView) {
        print("Did tap external view")
    }
}
