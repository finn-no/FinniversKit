//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class DrumMachineDemoView: UIView, Demoable {
    private lazy var drumMachineView = DrumMachineView()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview == nil {
            drumMachineView.stop()
        } else {
            drumMachineView.start()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(drumMachineView)
        drumMachineView.fillInSuperview()
    }
}
