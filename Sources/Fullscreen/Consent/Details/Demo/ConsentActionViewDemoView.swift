//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

class ConsentActionViewDemoView: UIView {

    let text = "Med GDPR-forordningen (General Data Protection Regulation) har du rett til å vite hva selskaper vet om deg. Det inkluderer informasjon du har delt med dem og data de har samlet om din aktivitet. Her kan du laste ned en oversikt over alle dine data FINN.no har lagret."

    lazy var consentActionView: ConsentActionView = {
        let view = ConsentActionView(frame: .zero)
        view.text = text
        view.buttonTitle = "Last ned data"
        view.buttonStyle = .callToAction
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConsentActionViewDemoView {

    func setupSubviews() {
        addSubview(consentActionView)
        consentActionView.fillInSuperview()
    }
}
