//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public class MotorTransactionEntryObjectPageDemoView: UIView {
    lazy var transactionView: MotorTransactionEntryObjectPageView = {
        let view = MotorTransactionEntryObjectPageView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = MotorTransactionEntryViewModel(
        title: "Salgsprosess",
        detail: "Betaling og eierskifte",
        description: "Kjøper har bekreftet. Dere må bekrefte før 8.februar 2020.",
        externalView: .init(text: "Mine kjøretøy", url: "https://www.finn.no/minekjoretoy"),
        style: "ERROR"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
}

private extension MotorTransactionEntryObjectPageDemoView {
    func setup() {
        addSubview(transactionView)

        NSLayoutConstraint.activate([
            transactionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            transactionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
        ])

        transactionView.configure(with: model)
    }
}

extension MotorTransactionEntryObjectPageDemoView: MotorTransactionEntryObjectPageViewDelegate {
    public func motorTransactionEntryObjectPageViewButtonWasTapped(_ view: MotorTransactionEntryObjectPageView) {
        print("Did tap button in MotorTransactionSummaryObjectPageDemoView")
    }
}
