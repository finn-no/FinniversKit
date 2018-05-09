//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConsentTransparencyDemoView: UIView {
    private lazy var shadedBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()

    private lazy var consentTransparencyView: ConsentTransparencyView = {
        let view = ConsentTransparencyView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .milk
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(shadedBackgroundView)
        shadedBackgroundView.addSubview(consentTransparencyView)

        shadedBackgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            consentTransparencyView.topAnchor.constraint(equalTo: shadedBackgroundView.topAnchor, constant: .largeSpacing),
            consentTransparencyView.leadingAnchor.constraint(equalTo: shadedBackgroundView.leadingAnchor, constant: .largeSpacing),
            consentTransparencyView.trailingAnchor.constraint(equalTo: shadedBackgroundView.trailingAnchor, constant: -.largeSpacing),
            consentTransparencyView.bottomAnchor.constraint(lessThanOrEqualTo: shadedBackgroundView.bottomAnchor, constant: -.largeSpacing),
        ])
    }
}
