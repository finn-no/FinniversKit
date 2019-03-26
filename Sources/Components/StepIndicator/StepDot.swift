//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol StepDotDelegate: AnyObject {
    func stepDotWasTapped(_ stepDot: StepDot)
}

class StepDot: UIView {
    enum State {
        case notStarted
        case inProgress
        case peeked
        case completed
    }

    // MARK: - Internal properties

    weak var delegate: StepDotDelegate?
    let stepIndex: Int

    // MARK: - Private properties

    private let diameter: CGFloat

    // MARK: - UI properties

    private lazy var outerCircle: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let radius = diameter / 2.0
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        shapeLayer.fillColor = UIColor.sardine.cgColor
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
        shapeLayer.fillColor = UIColor.milk.cgColor
        return shapeLayer
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented: init(coder:)")
    }

    override init(frame: CGRect) {
        fatalError("Not implemented: init(frame:)")
    }

    init(step: Int, diameter: CGFloat) {
        self.diameter = diameter
        self.stepIndex = step
        super.init(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        setup()
    }

    private func setup() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: diameter),
            heightAnchor.constraint(equalToConstant: diameter)
        ])

        layer.addSublayer(outerCircle)
        layer.addSublayer(innerCircle)
        addGestureRecognizer(tapRecognizer)
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
        case .notStarted:
            outerFill.toValue = StepIndicator.inactiveColor.cgColor
            innerSize.toValue = [ 0.9, 0.9 ]
        case .inProgress:
            outerFill.toValue = StepIndicator.activeColor.cgColor
            innerSize.toValue = [ 1.0, 1.0 ]
        case .peeked:
            outerFill.toValue = StepIndicator.activeColor.cgColor
            innerSize.toValue = [ 0.9, 0.9 ]
        case .completed:
            outerFill.toValue = StepIndicator.activeColor.cgColor
            innerSize.toValue = [ 0.0, 0.0 ]
        }

        outerCircle.add(outerFill, forKey: nil)
        innerCircle.add(innerSize, forKey: nil)
        CATransaction.commit()
    }

    // MARK: - Private methods

    @objc private func onTap() {
        delegate?.stepDotWasTapped(self)
    }
}
