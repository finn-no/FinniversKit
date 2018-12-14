//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class StarView: UIImageView, AttachableView {
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
        image = UIImage(named: .ornamentStar)
        contentMode = .scaleAspectFit
        isUserInteractionEnabled = true
    }

    // MARK: - Override methods

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType {
        return .path
    }

    override var collisionBoundingPath: UIBezierPath {
        let path = createStarPath(from: frame)

        var translation = CGAffineTransform(translationX: -frame.width / 2, y: -frame.height / 2)
        guard let movedPath = path.copy(using: &translation) else {
            return UIBezierPath(cgPath: path)
        }
        let mask = UIBezierPath(cgPath: movedPath)
        return mask
    }

    // MARK: - Private methods

    func createStarPath(from shapeFrame: CGRect) -> CGPath {
        // Code inspired this SO answer:
        // https://stackoverflow.com/questions/24767978/how-to-round-corners-of-uiimage-with-hexagon-mask/24770675#24770675
        let path = UIBezierPath()
        let sides = 5
        let cornerRadius: Double = 5

        // The angle to turn on each corner.
        let theta = 2.0 * .pi / Double(5)

        // Offset from which to start rounding corners.
        let offset = 5 * tan(theta / 2.0)

        let squareWidth = min(Double(shapeFrame.size.width), Double(shapeFrame.size.height))
        let length = squareWidth * cos(theta / 2.0) + offset/2.0
        let sideLength = length * tan(theta / 2.0)

        // Start drawing from lower right corner.
        var point = CGPoint(x: CGFloat(squareWidth / 2.0 + sideLength / 2.0 - offset), y: CGFloat(squareWidth - (squareWidth - length) / 2.0))
        var angle = Double.pi
        path.move(to: point)

        // Draw each side in the pentagon.
        for _ in (0..<sides) {
            point = CGPoint(x: CGFloat(Double(point.x) + (sideLength - offset * 2.0) * cos(angle)), y: CGFloat(Double(point.y) + (sideLength - offset * 2.0) * sin(angle)))
            path.addLine(to: point)

            let center = CGPoint(x: CGFloat(Double(point.x) + cornerRadius * cos(angle + (.pi / 2))), y: CGFloat(Double(point.y) + cornerRadius * sin(angle + (.pi / 2))))
            path.addArc(withCenter: center, radius: CGFloat(cornerRadius), startAngle: CGFloat(angle - (.pi / 2)), endAngle: CGFloat(angle + theta - (.pi / 2)), clockwise: true)

            point = path.currentPoint
            angle += theta
        }
        path.close()

        return path.cgPath
    }
}
