//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct AdReporterViewData: AdReporterViewModel {
    public var radioButtonTitle = "Hva gjelder det?"
    public var radioButtonFields = ["Mistanke om svindel", "Regelbrudd", "Forhandler opptrer som privat"]
    public var descriptionViewTitle = "Beskrivelse"
    public var descriptionViewPlaceholderText = "Beskriv kort hva problemet er"
    public var helpButtonText = "Trenger du hjelp?"

    public init() {}
}

class AdReporterDemoView: UIView {
    private lazy var adReporterView: AdReporterView = {
        let view = AdReporterView(frame: .zero)
        view.model = AdReporterViewData()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(adReporterView)
        NSLayoutConstraint.activate([
            adReporterView.leftAnchor.constraint(equalTo: leftAnchor),
            adReporterView.topAnchor.constraint(equalTo: topAnchor),
            adReporterView.rightAnchor.constraint(equalTo: rightAnchor),
            adReporterView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AdReporterDemoView: AdReporterDelegate {
    func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView) {
        print("Help button pressed")
        print("Message:", adReporterView.message)
    }

    func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem) {
        print("Did Select Item:", item)
    }

    func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem) {
        print("Did Unselect Item:", item)
    }
}
