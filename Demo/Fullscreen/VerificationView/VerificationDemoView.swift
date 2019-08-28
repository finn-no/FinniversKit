//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class VerificationDemoView: UIView {
    private lazy var verificationView: VerificationView = {
        let view = VerificationView(withAutoLayout: true)
        view.delegate = self
        view.model = VerificationViewDefaultData()
        return view
    }()

    public override init(frame: CGRect) {
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
        verificationView.show()
    }
}

extension VerificationDemoView: VerificationViewDelegate {
    public func didTapVerificationButton(_: VerificationView) {}
    public func didDismissVerificationView(_: VerificationView) {}
}
