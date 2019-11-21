//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class AdConfirmationDemoView: UIView {
    private lazy var confirmationView: AdConfirmationView = {
        let view = AdConfirmationView(withAutoLayout: true)
        view.delegate = self
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

extension AdConfirmationDemoView: AdConfirmationViewDelegate {
    func adConfirmationView( _ : AdConfirmationView, didTapActionButton button: UIButton) {
        print("Did tap action button:\(button)")
    }
}
