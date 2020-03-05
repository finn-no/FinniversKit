//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class ErrorDemoView: UIView {
    private lazy var errorView = ErrorView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        errorView.configure(
            title: "Klarte ikke å finne annonsen",
            description: "Det kan se ut som at annonsen du\nkikker etter er blitt slettet.",
            icon: UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
        )
        addSubview(errorView)
        errorView.fillInSuperview()
    }
}
