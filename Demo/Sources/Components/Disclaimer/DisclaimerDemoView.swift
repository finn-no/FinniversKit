//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

public class DisclaimerDemoView: UIView, Demoable {

    private lazy var disclaimerView: DisclaimerView = {
        let view = DisclaimerView(withAutoLayout: true)
        view.configure(with: DisclaimerViewModel.default)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(disclaimerView)

        NSLayoutConstraint.activate([
            disclaimerView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXL),
            disclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            disclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200)
        ])
    }
}

private extension DisclaimerViewModel {
    static var `default`: DisclaimerViewModel {
        let disclaimer = "Ved å legge inn din e-postadresse og ditt telefonnummer samtykker du til å motta e-poster samt eventuell henvendelse på telefon om boligprosjektet. Megler/utbygger blir selvstendig behandlingsansvarlig for personinformasjonen de mottar."
        let readMoreButtonTitle = "Les mer"
        return DisclaimerViewModel(disclaimerText: disclaimer, readMoreButtonTitle: readMoreButtonTitle)
    }
}
