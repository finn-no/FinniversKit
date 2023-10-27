//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class TriangleView: UIView, AttachableView {
    var attach: UIAttachmentBehavior?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
    }

    // MARK: - Override methods

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let path = createTrianglePath(from: rect)

        context.addPath(path)
        context.setFillColor(CGColor.backgroundPositiveSubtle)
        context.fillPath()
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

    override var collisionBoundingPath: UIBezierPath {
        let path = createTrianglePath(from: frame)

        var translation = CGAffineTransform(translationX: -bounds.size.width / 2, y: -bounds.size.height / 2)
        guard let movedPath = path.copy(using: &translation) else {
            return UIBezierPath(cgPath: path)
        }
        let mask = UIBezierPath(cgPath: movedPath)
        return mask
    }

    // MARK: - Methods

    private func createTrianglePath(from shapeFrame: CGRect) -> CGPath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: shapeFrame.width, y: shapeFrame.height))
        path.addLine(to: CGPoint(x: 0, y: shapeFrame.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()

        return path
    }
}
