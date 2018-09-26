//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class DrumMachineDemoView: UIView {
    private lazy var drumMachineView: DrumMachineView = {
        let drumMachineView = DrumMachineView()
        drumMachineView.translatesAutoresizingMaskIntoConstraints = false
        return drumMachineView
    }()

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

        NSLayoutConstraint.activate([
            drumMachineView.topAnchor.constraint(equalTo: topAnchor),
            drumMachineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            drumMachineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            drumMachineView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
