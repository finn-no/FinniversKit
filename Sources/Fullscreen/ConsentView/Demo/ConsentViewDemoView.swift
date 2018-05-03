//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConsentViewDemoView: UIView {
    private lazy var consentView: ConsentView = {
        let view = ConsentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        consentView.model = ConsentViewDefaultData()

        addSubview(consentView)

        NSLayoutConstraint.activate([
            consentView.topAnchor.constraint(equalTo: topAnchor),
            consentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            consentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            consentView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
