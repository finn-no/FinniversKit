//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ReportAdDemoView: UIView {
    private lazy var reportAdView: ReportAdView = {
        let view = ReportAdView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(reportAdView)
        NSLayoutConstraint.activate([
            reportAdView.leftAnchor.constraint(equalTo: leftAnchor),
            reportAdView.topAnchor.constraint(equalTo: topAnchor),
            reportAdView.rightAnchor.constraint(equalTo: rightAnchor),
            reportAdView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
