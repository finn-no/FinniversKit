//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class StepDotConnector: UIView {

    // MARK: - Private properties

    private var connected = false
    private var highlighted = false

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented: init(coder:)")
    }

    override init(frame: CGRect) {
        fatalError("Not implemented: init(frame:)")
    }

    init() {
        super.init(frame: .zero)

        backgroundColor = StepIndicator.inactiveColor
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Internal methods

    func connect(from: StepDot, to: StepDot) {
        guard !connected else { return }

        connected = true

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 4),
            leadingAnchor.constraint(equalTo: from.centerXAnchor),
            trailingAnchor.constraint(equalTo: to.centerXAnchor),
            centerYAnchor.constraint(equalTo: from.centerYAnchor)
        ])
    }

    func highlight() {
        guard !highlighted else { return }

        highlighted = true
        UIView.animate(withDuration: StepIndicator.animationDuration, animations: {
            self.backgroundColor = StepIndicator.activeColor
        })
    }
}
