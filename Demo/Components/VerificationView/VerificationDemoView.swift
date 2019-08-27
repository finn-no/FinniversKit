//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class VerificationDemoView: UIView {
    private lazy var verificationView: VerificationView = {
        let view = VerificationView(withAutoLayout: true)
        view.delegate = self
        view.model = VerificationDefaultData()
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
        NSLayoutConstraint.activate([
            verificationView.heightAnchor.constraint(equalToConstant: frame.height * 0.5),
            verificationView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            verificationView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            verificationView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension VerificationDemoView: VerificationViewDelegate {
    public func didTapVerificationButton(_: VerificationView) {
        print("didSelectVerificationButton")
    }
}
