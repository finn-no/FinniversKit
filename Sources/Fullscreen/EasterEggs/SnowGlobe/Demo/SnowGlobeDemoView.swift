//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SnowGlobeDemoView: UIView {
    private lazy var label: UILabel = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Shake me!"
        return label
    }()

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
            snowGlobeView.stop(animated: false)
        } else {
            becomeFirstResponder()
        }
    }

    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if event?.subtype == .motionShake {
            snowGlobeView.start(animated: true)
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(label)
        addSubview(snowGlobeView)

        snowGlobeView.fillInSuperview()
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
