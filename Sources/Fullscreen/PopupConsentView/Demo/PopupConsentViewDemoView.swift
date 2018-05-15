//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PopupConsentViewDemoView: UIView {
    private let maxScreenSize = CGSize(width: 414, height: 736)

    private lazy var shadedBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    private lazy var consentView: PopupConsentView = {
        let view = PopupConsentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .milk
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        consentView.model = PopupConsentViewDefaultData()

        addSubview(shadedBackgroundView)
        shadedBackgroundView.addSubview(consentView)

        shadedBackgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            consentView.topAnchor.constraint(greaterThanOrEqualTo: shadedBackgroundView.topAnchor, constant: .largeSpacing),
            consentView.bottomAnchor.constraint(lessThanOrEqualTo: shadedBackgroundView.bottomAnchor, constant: -.largeSpacing),
            consentView.leadingAnchor.constraint(greaterThanOrEqualTo: shadedBackgroundView.leadingAnchor, constant: .largeSpacing),
            consentView.trailingAnchor.constraint(lessThanOrEqualTo: shadedBackgroundView.trailingAnchor, constant: -.largeSpacing),
            consentView.centerXAnchor.constraint(equalTo: shadedBackgroundView.centerXAnchor),
            consentView.centerYAnchor.constraint(equalTo: shadedBackgroundView.centerYAnchor),
            consentView.widthAnchor.constraint(equalToConstant: maxScreenSize.width),
            consentView.heightAnchor.constraint(equalToConstant: maxScreenSize.height),
        ])
    }
}
