//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SnowGlobeDemoView: UIView {
    private lazy var snowGlobeView = SnowGlobeView()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil {
            snowGlobeView.stopAnimating()
        } else {
            snowGlobeView.becomeFirstResponder()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(snowGlobeView)
        snowGlobeView.fillInSuperview()
    }
}
