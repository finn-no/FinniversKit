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

    // MARK: - Overrides

    public override func didMoveToSuperview() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.calloutView.show(withText: "Trykk her i toppen for å se andre typer eiendommer som bolig til leie, fritidsboliger, tomter etc.")
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(calloutView)
        calloutView.hide()

        //let text =
        //calloutView.show(withText: text)

        NSLayoutConstraint.activate([
            calloutView.widthAnchor.constraint(equalToConstant: 320),
            calloutView.centerXAnchor.constraint(equalTo: centerXAnchor),
            calloutView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
