//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SnowGlobeDemoView: UIView {
    private lazy var snowGlobeView = SnowGlobeView()

    public override var canBecomeFirstResponder: Bool {
        return true
    }

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
            becomeFirstResponder()
        }
    }

    // MARK: - Motion

    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if event?.subtype == .motionShake {
            snowGlobeView.startAnimating()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(snowGlobeView)
        snowGlobeView.fillInSuperview()
    }
}
