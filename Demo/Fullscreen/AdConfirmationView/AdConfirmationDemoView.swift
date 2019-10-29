//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class AdConfirmationDemoView: UIView {
    private lazy var confirmationView: AdConfirmationView = {
        let view = AdConfirmationView(withAutoLayout: true)
        view.model = AdConfirmationViewDefaultData()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(confirmationView)
        confirmationView.fillInSuperview()
    }
}
