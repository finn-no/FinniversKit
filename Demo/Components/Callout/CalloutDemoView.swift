//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CalloutDemoView: UIView {
    private lazy var calloutView = CalloutView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(calloutView)
        calloutView.hide()

        let text = "Trykk her i toppen for å se andre typer eiendommer som bolig til leie, fritidsboliger, tomter etc."
        calloutView.show(withText: text, duration: 0)

        NSLayoutConstraint.activate([
            calloutView.widthAnchor.constraint(equalToConstant: 320),
            calloutView.centerXAnchor.constraint(equalTo: centerXAnchor),
            calloutView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
