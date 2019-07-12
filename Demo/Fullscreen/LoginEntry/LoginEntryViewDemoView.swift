//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public class LoginEntryViewDemoView: UIView {
    private lazy var loginEntryView: LoginEntryView = {
        let loginEntryView = LoginEntryView(withAutoLayout: true)
        loginEntryView.model = LoginEntryDemoData()

        return loginEntryView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(loginEntryView)
        loginEntryView.fillInSuperview()
    }
}
