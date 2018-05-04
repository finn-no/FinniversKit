//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PopupConsentViewDemoView: UIView {
    private lazy var consentView: PopupConsentView = {
        let view = PopupConsentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        consentView.model = PopupConsentViewDefaultData()

        addSubview(consentView)

        NSLayoutConstraint.activate([
            consentView.topAnchor.constraint(equalTo: topAnchor),
            consentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            consentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            consentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
