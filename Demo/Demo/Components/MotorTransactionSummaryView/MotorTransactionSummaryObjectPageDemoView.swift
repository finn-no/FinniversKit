//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class MotorTransactionSummaryObjectPageDemoView: UIView {
    lazy var transactionProcessSummaryView: MotorTransactionSummaryObjectPageView = {
        let view = MotorTransactionSummaryObjectPageView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    let model = MotorTransactionSummaryViewModel(
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

private extension MotorTransactionSummaryObjectPageDemoView {
    func setup() {
        addSubview(transactionProcessSummaryView)

        NSLayoutConstraint.activate([
            transactionProcessSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            transactionProcessSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
        ])

        transactionProcessSummaryView.configure(with: model)
    }
}

extension MotorTransactionSummaryObjectPageDemoView: MotorTransactionSummaryObjectPageViewDelegate {
    public func motorTransactionSummaryObjectPageViewButtonWasTapped(_ view: MotorTransactionSummaryObjectPageView) {
        print("Did tap button in MotorTransactionSummaryObjectPageDemoView")
    }
}
