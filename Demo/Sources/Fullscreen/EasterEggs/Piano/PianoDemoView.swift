//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class PianoDemoView: UIView, Demoable {
    var shouldSnapshotTest: Bool { false }

    private lazy var pianoView = PianoView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(pianoView)
        pianoView.fillInSuperview()
    }
}
