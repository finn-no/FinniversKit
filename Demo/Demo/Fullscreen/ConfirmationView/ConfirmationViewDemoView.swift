//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConfirmationViewDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let soldView = ConfirmationView(withAutoLayout: true)
        soldView.title = "Tusen takk for tipset!"
        soldView.message = "Vi vil ta en vurdering av annonsen."
        soldView.buttonTitle = "Tilbake til annonsen"

        addSubview(soldView)

        NSLayoutConstraint.activate([
            soldView.centerXAnchor.constraint(equalTo: centerXAnchor),
            soldView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
