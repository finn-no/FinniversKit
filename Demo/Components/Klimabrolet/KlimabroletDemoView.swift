//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct DemoKlimabroletViewModel: KlimabroletViewModel {
    let title: String = "Bli med og BRØØØL!"
    let subtitle: String = "30 August kl. 15.00"
    let bodyText: String = "Barn og unge over hele verden har samlet seg i gatene til støtte for miljøet. Ikke la dem stå alene. Bli med og brøl for klimaet!"
    let readMoreButtonTitle: String = "Les mer om Klimabrølet"
    let acceptButtonTitle: String = "Bli med på Klimabrølet!"
    let declineButtonTitle: String = "Nei takk"
}

class KlimabroletDemoView: UIView {
    private lazy var backgroundView = UIView()
    private lazy var klimabroletView: KlimabroletView = KlimabroletView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundView.backgroundColor = .black

        klimabroletView.model = DemoKlimabroletViewModel()

        addSubview(backgroundView)
        addSubview(klimabroletView)

        backgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            klimabroletView.widthAnchor.constraint(equalToConstant: 320),
            klimabroletView.heightAnchor.constraint(equalToConstant: 536),
            klimabroletView.centerXAnchor.constraint(equalTo: centerXAnchor),
            klimabroletView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
