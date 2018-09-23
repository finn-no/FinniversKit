import UIKit

public class LoadingIndicatorView: UIView {
    private var backgroundLayer = CAShapeLayer()
    private var animatedLayer = CAShapeLayer()
    private var animating = false
    private var duration: CGFloat = 3
    private var borderColor: UIColor = .secondaryBlue
    private var backgroundLayerColor: UIColor = .sardine
    private var lineWidth: CGFloat = 4

    public var isAnimating: Bool {
        return animating
    }

    public var hidesWhenStopped: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = UIColor.clear

        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = backgroundLayerColor.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = kCALineCapRound

        animatedLayer.fillColor = UIColor.clear.cgColor
        animatedLayer.strokeColor = borderColor.cgColor
        animatedLayer.strokeStart = 0
        animatedLayer.strokeEnd = 1
        animatedLayer.lineWidth = lineWidth
        animatedLayer.lineCap = kCALineCapRound

        isHidden = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
        let radius = min(self.bounds.size.width, self.bounds.size.height) / 2.0 - self.animatedLayer.lineWidth / 2.0

        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        backgroundLayer.path = bezierPath.cgPath
        animatedLayer.path = bezierPath.cgPath
        backgroundLayer.frame = self.bounds
        animatedLayer.frame = self.bounds
        isHidden = hidesWhenStopped

        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(animatedLayer)
    }

    private func animateStrokeEnd() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    private func animateStrokeStart() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        return animation
    }

    private func animateRotation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = .pi * 2.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = Float.infinity

        return animation
    }

    private func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = Float.infinity

        animatedLayer.add(animationGroup, forKey: "loading")
    }

    public func startAnimating() {
        animating = true
        isHidden = false
        animateGroup()
    }

    public func stopAnimating() {
        animating = false
        isHidden = hidesWhenStopped
        animatedLayer.removeAllAnimations()
    }
}
