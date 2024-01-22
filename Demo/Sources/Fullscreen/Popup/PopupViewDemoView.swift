//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class PopupViewDemoView: UIView, Demoable {
    private let maxScreenSize = CGSize(width: 320, height: 480)

    private lazy var shadedBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    private lazy var consentView: PopupView = {
        let view = PopupView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .bgPrimary
        view.layer.cornerRadius = 8
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        consentView.model = ConsentTransparencyViewModel()

        addSubview(shadedBackgroundView)
        shadedBackgroundView.addSubview(consentView)

        shadedBackgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            consentView.centerXAnchor.constraint(equalTo: shadedBackgroundView.centerXAnchor),
            consentView.centerYAnchor.constraint(equalTo: shadedBackgroundView.centerYAnchor),
            consentView.heightAnchor.constraint(equalToConstant: maxScreenSize.height),
            consentView.widthAnchor.constraint(equalToConstant: maxScreenSize.width)
        ])
    }
}
