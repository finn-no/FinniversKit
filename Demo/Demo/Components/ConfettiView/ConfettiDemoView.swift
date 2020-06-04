//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinnUI

class ConfettiDemoView: UIView {

    private lazy var confettiView: ConfettiView = {
        let view = ConfettiView(withAutoLayout: true)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(confettiView)
        confettiView.fillInSuperview()
    }

}
