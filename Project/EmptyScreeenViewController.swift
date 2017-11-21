//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class EmptyScreenViewController: UIViewController {

    // MARK: - Internal properties

    var square1 = UIView(frame: CGRect(x: 70, y: 130, width: 100, height: 100))
    var square2 = UIView(frame: CGRect(x: 230, y: 130, width: 90, height: 90))
    var square3 = UIView(frame: CGRect(x: 60, y: 45, width: 50, height: 50))
    var square4 = UIView(frame: CGRect(x: 260, y: 45, width: 55, height: 55))

    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior?
    var collision: UICollisionBehavior?
    var attach: UIAttachmentBehavior?
    var itemBehaviour: UIDynamicItemBehavior?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .milk

        square1.backgroundColor = .salmon
        square2.backgroundColor = .banana
        square3.backgroundColor = .mint
        square4.backgroundColor = .toothPaste

        view.addSubview(square1)
        view.addSubview(square2)
        view.addSubview(square3)
        view.addSubview(square4)

        let allSquares = [square1, square2, square3, square4]

        animator = UIDynamicAnimator(referenceView: view)

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

        // Setup pan gesture
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        let pan3 = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        let pan4 = UIPanGestureRecognizer(target: self, action: #selector(panAction))

        square1.addGestureRecognizer(pan1)
        square2.addGestureRecognizer(pan2)
        square3.addGestureRecognizer(pan3)
        square4.addGestureRecognizer(pan4)

        // Add behaviour to animator
        animator?.addBehavior(gravity!)
        animator?.addBehavior(collision!)
        animator?.addBehavior(itemBehaviour!)
    }

    @objc func panAction(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
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
            itemBehaviour.addLinearVelocity(sender.velocity(in: view), for: sender.view!)
            itemBehaviour.angularResistance = 0

            animator?.addBehavior(gravity!)
            animator?.addBehavior(collision!)
            animator?.addBehavior(itemBehaviour)
        }
    }
}
