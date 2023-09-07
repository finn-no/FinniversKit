//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class VerificationDemoView: UIView, Demoable {
    private lazy var verificationView: VerificationView = {
        let view = VerificationView(withAutoLayout: true)
        view.viewModel = VerificationViewDefaultData()
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

private extension VerificationDemoView {
    func setup() {
        addSubview(verificationView)
        verificationView.fillInSuperview()
    }
}

extension VerificationDemoView: VerificationViewDelegate {
    func didTapVerificationButton(_: VerificationView) {}
}
