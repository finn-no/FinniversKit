//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PopupConsentViewDemoView: UIView {
    private let plusScreenSize = CGSize(width: 414, height: 736)

    private lazy var consentView: PopupConsentView = {
        let view = PopupConsentView(frame: .zero)
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
            consentView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
            consentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            consentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            consentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            consentView.widthAnchor.constraint(equalToConstant: plusScreenSize.width),
            consentView.heightAnchor.constraint(equalToConstant: plusScreenSize.height),
        ])
    }
}
