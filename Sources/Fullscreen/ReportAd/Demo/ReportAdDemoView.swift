//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct ReportAdViewData: ReportAdViewModel {
    public var radioButtonTitle = "Hva gjelder det?"
    public var radioButtonFields = ["Mistanke om svindel", "Regelbrudd", "Forhandler opptrer som privat"]
    public var descriptionViewTitle = "Beskrivelse"
    public var descriptionViewPlaceholderText = "Beskriv kort hva problemet er"
    public var helpButtonText = "Trenger du hjelp?"

    public init() {}
}

class ReportAdDemoView: UIView {
    private lazy var reportAdView: ReportAdView = {
        let view = ReportAdView(frame: .zero)
        view.model = ReportAdViewData()
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
