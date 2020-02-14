//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class TransactionStepDot: UIView {
    enum State {
        case inProgress
        case completed
    }

    // MARK: - Internal properties

    let stepIndex: Int

    // MARK: - Private properties

    private let diameter: CGFloat = 26

    // MARK: - UI properties

    private lazy var outerCircle: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let radius = diameter / 2.0
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shapeLayer.fillColor = UIColor.textDisabled.cgColor
        shapeLayer.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        return shapeLayer
    }()

    private lazy var innerCircle: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let radius = (diameter / 2.0) - .smallSpacing

        let size = CGSize(width: self.bounds.width - .smallSpacing * 2,
                          height: self.bounds.height - .smallSpacing * 2)
        let bounds = CGRect(origin: .zero, size: size)
        let frame = CGRect(origin: CGPoint(x: .smallSpacing, y: .smallSpacing), size: size)

        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shapeLayer.frame = frame
        shapeLayer.fillColor = UIColor.bgPrimary.cgColor
        return shapeLayer
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented: init(coder:)")
    }

    override init(frame: CGRect) {
        fatalError("Not implemented: init(frame:)")
    }

    init(step: Int) {
        self.stepIndex = step

        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        translatesAutoresizingMaskIntoConstraints = false

        setup()
    }

    private func setup() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: diameter),
            heightAnchor.constraint(equalToConstant: diameter)
        ])

        layer.addSublayer(outerCircle)
        layer.addSublayer(innerCircle)
    }

    // MARK: - Internal methods

    func setState(_ state: State) {
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setAnimationDuration(StepIndicator.animationDuration)

        let outerFill = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.fillColor))
        outerFill.isRemovedOnCompletion = false
        outerFill.fillMode = .forwards

        let innerSize = CABasicAnimation(keyPath: "transform.scale")
        innerSize.isRemovedOnCompletion = false
        innerSize.fillMode = .forwards

        switch state {
        case .inProgress:
            outerFill.toValue = StepIndicator.activeColor.cgColor
            innerSize.toValue = [ 1.0, 1.0 ]
        case .completed:
            outerFill.toValue = StepIndicator.activeColor.cgColor
            innerSize.toValue = [ 0.0, 0.0 ]
        }

        outerCircle.add(outerFill, forKey: nil)
        innerCircle.add(innerSize, forKey: nil)
        CATransaction.commit()
    }
}
