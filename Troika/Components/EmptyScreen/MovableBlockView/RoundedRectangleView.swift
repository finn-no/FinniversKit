//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

internal class RoundedRectangleView: UIView {
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
            print("No context available")
            return
        }

        let path = createRoundedRectanglePath(from: rect)

        context.addPath(path)
        context.setFillColor(UIColor.mint.cgColor)
        context.fillPath()
    }

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

    override var collisionBoundingPath: UIBezierPath {
        let path = createRoundedRectanglePath(from: frame)

        var translation = CGAffineTransform(translationX: -frame.width / 2, y: -frame.height / 2)
        guard let movedPath = path.copy(using: &translation) else {
            print("Cannot translate the path")
            return UIBezierPath(cgPath: path)
        }
        let mask = UIBezierPath(cgPath: movedPath)
        return mask
    }

    // MARK: - Methods

    private func createRoundedRectanglePath(from shapeFrame: CGRect) -> CGPath {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeFrame.width, height: shapeFrame.height), byRoundingCorners: .topRight, cornerRadii: CGSize(width: shapeFrame.width * 2, height: shapeFrame.height * 2))
        return path.cgPath
    }
}
