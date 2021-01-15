//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class MotorTransactionEntryAdManagementDemoView: UIView {
    lazy var transactionView: MotorTransactionEntryAdManagementView = {
        let view = MotorTransactionEntryAdManagementView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = MotorTransactionEntryViewModel(
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

private extension MotorTransactionEntryAdManagementDemoView {
    func setup() {
        addSubview(transactionView)

        NSLayoutConstraint.activate([
            transactionView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            transactionView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])

        transactionView.configure(with: model, shouldShowExternalView: true)
    }
}

extension MotorTransactionEntryAdManagementDemoView: MotorTransactionEntryAdManagementViewDelegate {
    public func motorTransactionEntryViewWasTapped(_ view: MotorTransactionEntryAdManagementView) {
        print("Did tap summary view")
    }

    public func motorTransactionEntryExternalViewWasTapped(_ view: MotorTransactionEntryAdManagementView) {
        print("Did tap external view")
    }
}
