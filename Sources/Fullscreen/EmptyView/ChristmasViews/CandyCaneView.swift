//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class CandyCaneView: UIImageView, AttachableView {
    var attach: UIAttachmentBehavior?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }

    // MARK: - Setup

    private func setup() {
        image = UIImage(named: .candyCane)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

    override var collisionBoundingPath: UIBezierPath {
        let path = createCandyCanePath(from: frame)

        var translation = CGAffineTransform(translationX: -frame.width / 2, y: -frame.height / 2)
        guard let movedPath = path.copy(using: &translation) else {
            return UIBezierPath(cgPath: path)
        }
        let mask = UIBezierPath(cgPath: movedPath)

        return mask
    }

    // MARK: - Private methods

    func createCandyCanePath(from shapeFrame: CGRect) -> CGPath {
        let path = UIBezierPath()

        let headCircleCenter = CGPoint(x: shapeFrame.width / 2, y: shapeFrame.width / 2)
        let candyCaneWidth = shapeFrame.width / 1.9
        path.addArc(withCenter: headCircleCenter, radius: shapeFrame.width / 2, startAngle: 0, endAngle: 90, clockwise: false)
        path.addLine(to: CGPoint(x: shapeFrame.width - candyCaneWidth, y: shapeFrame.height))
        path.addLine(to: CGPoint(x: shapeFrame.width, y: shapeFrame.height))
        path.close()

        return path.cgPath
    }
}
