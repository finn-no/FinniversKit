//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ConsentTransparencyInfoDemoView: UIView {
    private lazy var consentTransparencyInfoView: ConsentTransparencyInfoView = {
        let view = ConsentTransparencyInfoView(isUserLoggedIn: true)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(consentTransparencyInfoView)

        consentTransparencyInfoView.fillInSuperview()
    }
}
