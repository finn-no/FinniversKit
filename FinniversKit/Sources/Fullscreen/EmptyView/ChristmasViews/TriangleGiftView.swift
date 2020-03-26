//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class TriangleGiftView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Setup

    private func setup() {
        image = UIImage(named: .giftTriangleGreen)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

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

    // MARK: - Private methods

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
