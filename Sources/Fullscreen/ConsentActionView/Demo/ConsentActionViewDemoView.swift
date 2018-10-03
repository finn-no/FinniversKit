//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

struct ActionViewModel: ConsentActionViewModel {
    var text = "Med GDPR-forordningen (General Data Protection Regulation) har du rett til å vite hva selskaper vet om deg. Det inkluderer informasjon du har delt med dem og data de har samlet om din aktivitet. Her kan du laste ned en oversikt over alle dine data FINN.no har lagret."
    var buttonStyle: Button.Style = .callToAction
    var buttonTitle = "Last ned data"
    var indexPath = IndexPath(row: 0, section: 0)
}

class ConsentActionViewDemoView: UIView {

    lazy var consentActionView: ConsentActionView = {
        let view = ConsentActionView(frame: .zero)
        view.model = ActionViewModel()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConsentActionViewDemoView {
    func setupSubViews() {
        addSubview(consentActionView)
        consentActionView.fillInSuperview()
    }
}
