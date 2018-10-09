//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class DrumMachineDemoView: UIView {
    private lazy var drumMachineView = DrumMachineView()

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
