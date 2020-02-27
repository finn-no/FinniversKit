//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class TransactionStepDotConnector: UIView {

    // MARK: - Internal properties

    var highlighted = false {
        didSet {
            if oldValue != highlighted {
                let color = highlighted ? TransactionStepDot.activeColor : TransactionStepDot.inactiveColor
                transition(toColor: color)
            }
        }
    }

    // MARK: - Private properties

    private var connected = false

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

    func connect(from: TransactionStepDot, to: TransactionStepDot) {
        guard !connected else { return }

        connected = true
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: 4)])
    }

    // MARK: - Private methods

    private func transition(toColor color: UIColor) {
        UIView.animate(withDuration: StepIndicator.animationDuration, animations: {
            self.backgroundColor = color
        })
    }
}
