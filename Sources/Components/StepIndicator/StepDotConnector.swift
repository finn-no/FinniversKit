//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class StepDotConnector: UIView {

    // MARK: - Internal properties

    var highlighted = false {
        didSet {
            if oldValue != highlighted {
                let color = highlighted ? StepIndicator.activeColor : StepIndicator.inactiveColor
                transition(toColor: color)
            }
        }
    }

    // MARK: - Private properties

    private var connected = false
    private var axis: NSLayoutConstraint.Axis

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented: init(coder:)")
    }

    override init(frame: CGRect) {
        fatalError("Not implemented: init(frame:)")
    }

    init(axis: NSLayoutConstraint.Axis) {
        self.axis = axis

        super.init(frame: .zero)

        backgroundColor = StepIndicator.inactiveColor
        translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Internal methods

    func connect(from: StepDot, to: StepDot) {
        guard !connected else { return }

        connected = true
        switch axis {
        case .horizontal:
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: 4),
                leadingAnchor.constraint(equalTo: from.centerXAnchor),
                trailingAnchor.constraint(equalTo: to.centerXAnchor),
                centerYAnchor.constraint(equalTo: from.centerYAnchor)
            ])
        case .vertical:
            NSLayoutConstraint.activate([
                widthAnchor.constraint(equalToConstant: 4),
                heightAnchor.constraint(equalTo: to.heightAnchor),
                bottomAnchor.constraint(equalTo: to.topAnchor),
                centerXAnchor.constraint(equalTo: from.centerXAnchor),
            ])
        default:  return
        }
    }

    // MARK: - Private methods

    private func transition(toColor color: UIColor) {
        UIView.animate(withDuration: StepIndicator.animationDuration, animations: {
            self.backgroundColor = color
        })
    }
}
