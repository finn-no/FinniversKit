//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

public class TransactionProcessDemoView: UIView {
    let transactionProcessView = TransactionProcessView(withAutoLayout: true)
    let model = TransactionProcessViewModel(
        title: "Salgsprosess",
        detail: "Kontrakt",
        description: "Når du har funnet en kjøper er det neste steget å skrive en kontrakt"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
}

private extension TransactionProcessDemoView {
    func setup() {
        addSubview(transactionProcessView)

        NSLayoutConstraint.activate([
            transactionProcessView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            transactionProcessView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])

        transactionProcessView.configure(with: model)
    }
}
