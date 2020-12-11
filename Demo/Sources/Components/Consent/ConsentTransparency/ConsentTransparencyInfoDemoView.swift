//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConsentTransparencyInfoDemoView: UIView {
    private let maxScreenWidth: CGFloat = 800.0

    private lazy var consentTransparencyInfoView: ConsentTransparencyInfoView = {
        let view = ConsentTransparencyInfoView(showSettingsButtons: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(consentTransparencyInfoView)

        consentTransparencyInfoView.model = ConsentTransparencyInfoDefaultData()

        NSLayoutConstraint.activate([
            consentTransparencyInfoView.topAnchor.constraint(equalTo: topAnchor),
            consentTransparencyInfoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            consentTransparencyInfoView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            consentTransparencyInfoView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            consentTransparencyInfoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            consentTransparencyInfoView.widthAnchor.constraint(lessThanOrEqualToConstant: maxScreenWidth)
        ])
    }
}
