//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import CoreMotion

public class EmptyScreen: UIView {

    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 4.0

    private lazy var square1: UIView = {
        let view = UIView(frame: CGRect(x: 70, y: 130, width: 100, height: 100))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .salmon
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var square2: UIView = {
        let view = UIView(frame: CGRect(x: 230, y: 130, width: 90, height: 90))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .banana
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var square3: UIView = {
        let view = UIView(frame: CGRect(x: 60, y: 45, width: 50, height: 50))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .mint
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var square4: UIView = {
        let view = UIView(frame: CGRect(x: 260, y: 45, width: 55, height: 55))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .toothPaste
        view.layer.cornerRadius = cornerRadius
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
        let label = Label(style: .title4(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private var animator: UIDynamicAnimator?
    private var gravity: UIGravityBehavior?
    private var collision: UICollisionBehavior?
    private var attach: UIAttachmentBehavior?
    private var itemBehaviour: UIDynamicItemBehavior?

    private var motionManager: CMMotionManager?
    private var motionQueue: OperationQueue?

    // MARK: - External properties / Dependency injection

    public var header: String = "" {
        didSet {
            headerLabel.text = header
        }
    }

    public var message: String = "" {
        didSet {
            messageLabel.text = message
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
        addSubview(square1)
        addSubview(square2)
        addSubview(square3)
        addSubview(square4)

        addSubview(headerLabel)
        addSubview(messageLabel)

        let allSquares = [square1, square2, square3, square4]

        animator = UIDynamicAnimator(referenceView: self)

        // Setup gravity
        gravity = UIGravityBehavior(items: allSquares)
        let direction = CGVector(dx: 0, dy: 1.0)
        gravity?.gravityDirection = direction

        // Setup boundries for collision
        collision = UICollisionBehavior(items: allSquares)
        collision?.translatesReferenceBoundsIntoBoundary = true

        // Setup elasticity for bounce
        itemBehaviour = UIDynamicItemBehavior(items: allSquares)
        itemBehaviour?.elasticity = 0.6

        // Add behaviour to animator
        animator?.addBehavior(gravity!)
        animator?.addBehavior(collision!)
        animator?.addBehavior(itemBehaviour!)

        getAccelerometerData()
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .largeSpacing),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func panAction(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self)
        let touchLocation = sender.location(in: sender.view)

        if sender.state == .began {
            let touchOffset = UIOffsetMake(touchLocation.x - sender.view!.bounds.midX, touchLocation.y - sender.view!.bounds.midY)
            attach = UIAttachmentBehavior(item: sender.view!, offsetFromCenter: touchOffset, attachedToAnchor: location)
            animator?.addBehavior(attach!)
        } else if sender.state == .changed {
            attach?.anchorPoint = location
        } else if sender.state == .ended {
            animator?.removeBehavior(attach!)

            let itemBehaviour = UIDynamicItemBehavior(items: [sender.view!])
            itemBehaviour.addLinearVelocity(sender.velocity(in: self), for: sender.view!)
            itemBehaviour.angularResistance = 0

            animator?.addBehavior(gravity!)
            animator?.addBehavior(collision!)
            animator?.addBehavior(itemBehaviour)
        }
    }

    func getAccelerometerData() {
        // Setup motion amanager
        motionManager = CMMotionManager()
        motionQueue = OperationQueue()

        guard let motionManager = motionManager else {
            print("No motion manager available")
            return
        }
        guard let motionQueue = motionQueue else {
            print("No motion queue available")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.01
        motionManager.startAccelerometerUpdates()

        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { motion, error in
            if error != nil {
                NSLog(String(describing: error))
            }

            let grav: CMAcceleration = motion!.gravity
            var vector = CGVector(dx: CGFloat(grav.x), dy: CGFloat(grav.y))

            DispatchQueue.main.async {
                // Have to correct for orientation.
                let orientation = UIApplication.shared.statusBarOrientation

                if orientation == .portrait {
                    vector.dy *= -1
                } else if orientation == .landscapeLeft {
                    vector.dx = CGFloat(grav.y)
                    vector.dy = CGFloat(grav.x)
                } else if orientation == .landscapeRight {
                    vector.dx = CGFloat(-grav.y)
                    vector.dy = CGFloat(-grav.x)
                }

                self.gravity!.gravityDirection = vector
            }
        })
    }
}
