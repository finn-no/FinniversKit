import FinniversKit

protocol CornerAnchoringViewDelegate: AnyObject {
    func cornerAnchoringViewDidSelectTweakButton(_ cornerAnchoringView: CornerAnchoringView)
}

class CornerAnchoringView: UIView {
    weak var delegate: CornerAnchoringViewDelegate?

    private lazy var anchoredView: FloatingButton = {
        let button = FloatingButton(withAutoLayout: true)
        button.tintColor = .btnPrimary
        button.setImage(UIImage(named: .wrench).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(tweakButtonAction), for: .touchUpInside)
        return button
    }()

    private var anchorAreaViews = [UIView]()
    private let panRecognizer = UIPanGestureRecognizer()
    private var initialOffset: CGPoint = .zero

    private var anchorPositions: [CGPoint] {
        return anchorAreaViews.map { $0.center }
    }

    public var itemsCount: Int = 0 {
        didSet {
            anchoredView.itemsCount = itemsCount
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let topLeftView = addAnchorAreaView()
        topLeftView.accessibilityIdentifier = "CornerAnchoringView-topLeftView"

        let topRightView = addAnchorAreaView()
        topRightView.accessibilityIdentifier = "CornerAnchoringView-topRightView"

        let bottomLeftView = addAnchorAreaView()
        bottomLeftView.accessibilityIdentifier = "CornerAnchoringView-bottomLeftView"

        let bottomRightView = addAnchorAreaView()
        bottomRightView.accessibilityIdentifier = "CornerAnchoringView-bottomRightView"

        addSubview(anchoredView)

        let buttonSize = CGFloat.spacingXXL
        let halfButtonSize = buttonSize / 2.0

        NSLayoutConstraint.activate([
            topLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM + halfButtonSize),
            topLeftView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM + halfButtonSize),

            topRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM - halfButtonSize),
            topRightView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM + halfButtonSize),

            bottomLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM + halfButtonSize),
            bottomLeftView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingM - halfButtonSize),

            bottomRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM - halfButtonSize),
            bottomRightView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingM - halfButtonSize),

            anchoredView.widthAnchor.constraint(equalToConstant: buttonSize),
            anchoredView.heightAnchor.constraint(equalToConstant: buttonSize)
        ])

        panRecognizer.addTarget(self, action: #selector(anchoredViewPanned(recognizer:)))
        anchoredView.addGestureRecognizer(panRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let index = DemoState.lastCornerForTweakingButton {
            anchoredView.center = anchorPositions[index]
        } else {
            anchoredView.center = anchorPositions.last ?? .zero
        }
    }

    private func addAnchorAreaView() -> UIView {
        let view = UIView(withAutoLayout: true)
        addSubview(view)
        anchorAreaViews.append(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 0),
            view.heightAnchor.constraint(equalToConstant: 0)
        ])
        view.isUserInteractionEnabled = false
        return view
    }

    @objc private func anchoredViewPanned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - anchoredView.center.x, y: touchPoint.y - anchoredView.center.y)
        case .changed:
            anchoredView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            let velocity = recognizer.velocity(in: self)
            let projectedPosition = CGPoint(
                x: anchoredView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: anchoredView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let (index, nearestCornerPosition) = nearestCorner(to: projectedPosition)
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(forVelocity: velocity.x, from: anchoredView.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(forVelocity: velocity.y, from: anchoredView.center.y, to: nearestCornerPosition.y)
            )
            DemoState.lastCornerForTweakingButton = index
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.anchoredView.center = nearestCornerPosition
            }
            animator.startAnimation()
        default: break
        }
    }

    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }

    /// Finds the position of the nearest corner to the given point.
    private func nearestCorner(to point: CGPoint) -> (Int, CGPoint) {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestPosition = CGPoint.zero
        var arrayIndex = 0
        for (index, position) in anchorPositions.enumerated() {
            let distance = point.distance(to: position)
            if distance < minDistance {
                closestPosition = position
                arrayIndex = index
                minDistance = distance
            }
        }
        return (arrayIndex, closestPosition)
    }

    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }

    /// Forwards all touches not applied to subviews.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            !$0.isHidden && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }

    @objc private func tweakButtonAction() {
        delegate?.cornerAnchoringViewDidSelectTweakButton(self)
    }
}

extension UISpringTimingParameters {

    /// A design-friendly way to create a spring timing curve.
    ///
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }

}

extension CGPoint {

    /// Calculates the distance between two points in 2D space.
    /// + returns: The distance from this point to the given point.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }

}
