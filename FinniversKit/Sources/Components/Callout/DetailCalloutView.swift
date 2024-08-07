//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public final class DetailCalloutView: UIView {

    public enum Direction: CaseIterable {
        case left
        case right
    }

    private let direction: Direction

    private var arrowRotationTransformation: CGAffineTransform {
        switch direction {
        case .left:
            return .identity
        case .right:
            return CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }

    private lazy var boxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = Warp.UIColor.calloutBackground
        view.layer.borderColor = Warp.UIColor.calloutBorder.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = Warp.Spacing.spacing100
        return view
    }()

    private lazy var arrowView: UIView = {
        let view = ArrowView(withAutoLayout: true)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .text
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        direction = .left
        super.init(frame: frame)
        setup()
    }

    public init(direction: DetailCalloutView.Direction, numberOfLines: Int = 0) {
        self.direction = direction
        super.init(frame: .zero)
        textLabel.numberOfLines = numberOfLines
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func configure(withText text: String) {
        textLabel.text = text
    }

    // MARK: - Setup

    private func setup() {
        addSubview(boxView)
        addSubview(arrowView)
        addSubview(textLabel)

        arrowView.transform = arrowRotationTransformation

        let defaultConstraints = [
            arrowView.widthAnchor.constraint(equalToConstant: 9),
            arrowView.heightAnchor.constraint(equalToConstant: 16),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),

            textLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: Warp.Spacing.spacing100),
            textLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: Warp.Spacing.spacing200),
            textLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -Warp.Spacing.spacing200),
            textLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -Warp.Spacing.spacing100)
        ]

        NSLayoutConstraint.activate(defaultConstraints + directionConstraints())
    }

    private func directionConstraints() -> [NSLayoutConstraint] {
        switch direction {
        case .left:
            return [
                arrowView.leadingAnchor.constraint(equalTo: leadingAnchor),
                boxView.leadingAnchor.constraint(equalTo: arrowView.trailingAnchor, constant: -boxView.layer.borderWidth - 1),
                boxView.topAnchor.constraint(equalTo: topAnchor),
                boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
                boxView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        case .right:
            return [
                arrowView.trailingAnchor.constraint(equalTo: trailingAnchor),
                boxView.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: boxView.layer.borderWidth + 1),
                boxView.topAnchor.constraint(equalTo: topAnchor),
                boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
                boxView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        }
    }

}

// MARK: - Private types

private final class ArrowView: UIView {

    private lazy var triangleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.fillColor = Warp.UIColor.calloutBackground.cgColor
        layer.strokeColor = Warp.UIColor.calloutBorder.cgColor
        return layer
    }()

    private lazy var trailingBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = Warp.UIColor.calloutBackground.cgColor
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        layer.addSublayer(triangleLayer)
        layer.addSublayer(trailingBorderLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let path = CGMutablePath()
        let bottomBorderHeight: CGFloat = 1
        let pathWidth = rect.maxX - bottomBorderHeight

        let point1 = CGPoint(x: pathWidth, y: rect.minY)
        let point2 = CGPoint(x: rect.minX, y: rect.midY)
        let point3 = CGPoint(x: pathWidth, y: rect.maxY)

        let radius: CGFloat = 2

        path.move(to: point1)
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addLine(to: CGPoint(x: pathWidth, y: rect.maxY))

        triangleLayer.path = path
        trailingBorderLayer.frame = CGRect(x: pathWidth, y: rect.minY, width: bottomBorderHeight, height: rect.height)
    }
}
