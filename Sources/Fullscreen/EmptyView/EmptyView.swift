//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import CoreMotion
import UIKit

public protocol EmptyViewDelegate: class {
    func emptyView(_ emptyView: EmptyView, didSelectActionButton button: Button)
    func emptyView(_ emptyView: EmptyView, didMoveObjectView view: UIView)
}

public class EmptyView: UIView {

    // MARK: - Internal properties

    private let sizeOfTriangle = CGSize(width: 90, height: 90)
    private let sizeOfCircle = CGSize(width: 75, height: 75)
    private let sizeOfRoundedSquare = CGSize(width: 55, height: 55)
    private let sizeOfRectangle = CGSize(width: 100, height: 100)
    private let sizeOfSquare = CGSize(width: 50, height: 50)

    private var hasLayedOut = false

    private lazy var triangle: TriangleView = {
        let view = TriangleView(frame: CGRect(x: 0, y: 0, width: sizeOfTriangle.width, height: sizeOfTriangle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var circle: CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: sizeOfCircle.width, height: sizeOfCircle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var roundedSquare: RoundedRectangleView = {
        let view = RoundedRectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfRoundedSquare.width, height: sizeOfRoundedSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var rectangle: RectangleView = {
        let view = RectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfRectangle.width, height: sizeOfRectangle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var square: RectangleView = {
        let view = RectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfSquare.width, height: sizeOfSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .salmon
        return view
    }()

    private lazy var headerLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        button.isHidden = true // Default is hidden. When a title is set it will be displayed.
        return button
    }()

    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        return animator
    }()

    private lazy var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior(items: allShapes)
        gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
        return gravity
    }()

    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior(items: allShapes)
        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsetsMake(-10000, 0, 0, 0))
        return collision
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: allShapes)
        itemBehavior.elasticity = 0.5
        itemBehavior.friction = 0.3
        itemBehavior.angularResistance = 0.1
        itemBehavior.resistance = 0.1
        itemBehavior.density = 0.75
        return itemBehavior
    }()

    private lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 1 / 60
        return motionManager
    }()

    private lazy var motionQueue = OperationQueue()

    private lazy var allShapes: [UIView] = {
        return [rectangle, triangle, roundedSquare, circle, square]
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: EmptyViewDelegate?

    public var header: String = "" {
        didSet {
            headerLabel.text = header
            headerLabel.accessibilityLabel = header
        }
    }

    public var message: String = "" {
        didSet {
            messageLabel.text = message
            messageLabel.accessibilityLabel = message
        }
    }

    public var actionButtonTitle: String = "" {
        didSet {
            actionButton.setTitle(actionButtonTitle, for: .normal)
            actionButton.accessibilityLabel = actionButtonTitle
            actionButton.isHidden = actionButtonTitle.isEmpty
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = .milk

        addSubview(rectangle)
        addSubview(triangle)
        addSubview(roundedSquare)
        addSubview(circle)
        addSubview(square)

        addSubview(headerLabel)
        addSubview(messageLabel)
        addSubview(actionButton)

        getAccelerometerData()

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .largeSpacing),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .largeSpacing),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // We only want to lay out once
        guard hasLayedOut == false else {
            return
        }

        let slice = frame.width / 8

        // We reposition the shapes after the EmptyView itself has layed out its frame.
        // At this point we will have its size even if we use constraints to lay it out.
        triangle.center = CGPoint(x: slice, y: frame.height - (sizeOfTriangle.height / 2))
        circle.center = CGPoint(x: slice * 2, y: frame.height - (sizeOfCircle.height / 2))
        square.center = CGPoint(x: slice * 3, y: frame.height - (sizeOfSquare.height / 2))
        roundedSquare.center = CGPoint(x: slice * 5, y: frame.height - (sizeOfRoundedSquare.height / 2))
        rectangle.center = CGPoint(x: slice * 7, y: frame.height - (sizeOfRectangle.height / 2))

        // We add the behaviors after laying out the subviews to avoid issues with initial positions of the shapes
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)

        hasLayedOut = true
    }

    // MARK: - Actions

    @objc func panAction(sender: UIPanGestureRecognizer) {
        guard let objectView = sender.view, var attachable = objectView as? AttachableView else {
            return
        }

        let location = sender.location(in: self)
        let touchLocation = sender.location(in: objectView)
        let touchOffset = UIOffsetMake(touchLocation.x - objectView.bounds.midX, touchLocation.y - objectView.bounds.midY)

        if sender.state == .began {
            let newAttach = UIAttachmentBehavior(item: objectView, offsetFromCenter: touchOffset, attachedToAnchor: location)
            animator.addBehavior(newAttach)
            attachable.attach = newAttach
        } else if sender.state == .changed {
            if let attach = attachable.attach {
                attach.anchorPoint = location
            }
        } else if sender.state == .ended {
            if let attach = attachable.attach {
                animator.removeBehavior(attach)
                itemBehavior.addLinearVelocity(sender.velocity(in: self), for: objectView)
                delegate?.emptyView(self, didMoveObjectView: objectView)
            }
        }
    }

    @objc private func performAction() {
        delegate?.emptyView(self, didSelectActionButton: actionButton)
    }

    // MARK: - Accelerometer calculations

    func getAccelerometerData() {
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { motion, error in
            if error != nil {
                return
            }

            guard let motion = motion else {
                return
            }

            let gravity: CMAcceleration = motion.gravity
            var vector = CGVector(dx: CGFloat(gravity.x), dy: CGFloat(gravity.y))

            DispatchQueue.main.async {
                // Correct for orientation
                let orientation = UIApplication.shared.statusBarOrientation

                switch orientation {
                case .portrait:
                    vector.dy *= -1
                case .landscapeLeft:
                    vector.dx = CGFloat(gravity.y)
                    vector.dy = CGFloat(gravity.x)
                case .landscapeRight:
                    vector.dx = CGFloat(-gravity.y)
                    vector.dy = CGFloat(-gravity.x)
                default: break
                }

                self.gravity.gravityDirection = vector
            }
        })
    }
}
