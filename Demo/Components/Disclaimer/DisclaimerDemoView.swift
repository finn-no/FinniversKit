//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class DisclaimerDemoView: UIView {

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
            disclaimerView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            disclaimerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            disclaimerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
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
