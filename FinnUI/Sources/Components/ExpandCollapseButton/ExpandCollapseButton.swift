//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public class ExpandCollapseButton: UIButton {
    private var expanded = false {
        didSet {
            shapeLayer.path = expanded ? collapsePath() : expandPath()
        }
    }

    private let shapeLayer: CAShapeLayer

    public override var isHighlighted: Bool {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            shapeLayer.strokeColor = (isHighlighted ? tintColor.withAlphaComponent(0.7) : tintColor).cgColor
            CATransaction.commit()
        }
    }

    private let iconView: UIView

    // MARK: - Init

    public override init(frame: CGRect) {
        iconView = UIView(frame: frame)
        shapeLayer = CAShapeLayer()
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.lineWidth = frame.width * 0.0454
        shapeLayer.fillColor = nil
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shapeLayer.frame = frame
        shapeLayer.isGeometryFlipped = true
        iconView.layer.addSublayer(shapeLayer)
        iconView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
        iconView.isUserInteractionEnabled = false
        addSubview(iconView)
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame.origin = CGPoint(x: bounds.width - iconView.frame.width, y: 0)
    }

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        shapeLayer.strokeColor = tintColor.cgColor
    }

    // MARK: - Public methods

    public func setExpanded(_ expanded: Bool, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.23
            animation.fromValue = expanded ? expandPath() : collapsePath()
            animation.toValue = expanded ? collapsePath() : expandPath()
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            shapeLayer.add(animation, forKey: "pathAnimation")
        }
        self.expanded = expanded
    }

    // MARK: - Private methods

    private func expandPath() -> CGPath {
        let path = circlePath()

        let icon = UIBezierPath()
        let rect = path.bounds.insetBy(dx: 4, dy: 4)
        let visualCompensation: CGFloat = 1
        icon.move(to: CGPoint(x: rect.minX, y: rect.midY + visualCompensation))
        icon.addLine(to: CGPoint(x: rect.midX, y: rect.midY - (rect.height / 3) + visualCompensation))
        icon.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + visualCompensation))

        path.append(icon)

        return path.cgPath
    }

    private func collapsePath() -> CGPath {
        let path = circlePath()

        let icon = UIBezierPath()
        let rect = path.bounds.insetBy(dx: 4, dy: 4)
        icon.move(to: CGPoint(x: rect.minX, y: rect.midY))
        icon.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        icon.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        path.append(icon)

        return path.cgPath
    }

    private func circlePath() -> UIBezierPath {
        let rect = shapeLayer.bounds.insetBy(dx: shapeLayer.bounds.width * 0.27, dy: shapeLayer.bounds.height * 0.27)
        let path = UIBezierPath()
        path.addArc(withCenter: shapeLayer.position,
                    radius: rect.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat((360.0 * Double.pi) / 180.0),
                    clockwise: true)
        path.close()
        return path
    }
}
