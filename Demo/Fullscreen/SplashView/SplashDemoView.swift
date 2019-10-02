//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SplashDemoView: UIView {
    private lazy var view = SplashView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.view.animate()
        })
    }
}
