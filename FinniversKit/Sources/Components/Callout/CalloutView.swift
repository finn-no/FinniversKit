//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class CalloutView: UIView {

    public enum Direction: CaseIterable {
        case up
        case down
    }

    public enum ArrowAlignment {
        case center
        case left(CGFloat)
        case right(CGFloat)
    }

    private let direction: Direction
    private let arrowAlignment: ArrowAlignment

    private var arrowRotationTransformation: CGAffineTransform {
        switch direction {
        case .up:
            return .identity
        case .down:
            return CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }

    private lazy var boxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgSuccess
        view.layer.borderColor = .accentPea
        view.layer.borderWidth = 2
        view.layer.cornerRadius = .spacingS
        return view
    }()

    private lazy var arrowView: UIView = {
        let view = ArrowView(withAutoLayout: true)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont.font(ofSize: 16.0, weight: .bold, textStyle: .callout)
        label.textColor = .textToast
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        direction = .up
        arrowAlignment = .center
        super.init(frame: frame)
        setup()
    }

    public init(direction: CalloutView.Direction, arrowAlignment: ArrowAlignment = .center) {
        self.direction = direction
        self.arrowAlignment = arrowAlignment
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    /// Presents the callout by fading it into the screen with a given text
    ///
    /// **Note**: you need to make sure the `alpha` property of the callout is 0 before calling this method
    /// - Parameters:
    ///   - text: content of the callout
    ///   - duration: animation duration
    ///   - completion: optional callback for when the animation completes
    public func show(withText text: String, duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2
        paragraph.alignment = .center

        textLabel.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraph])

        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.alpha = 1
            },
            completion: completion
        )
    }

    /// Fades out the presented callout
    /// - Parameters:
    ///   - duration: animation duration
    ///   - completion: optional callback for when the animation completes
    public func hide(duration: TimeInterval = 0.3, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: duration,
            animations: { [weak self] in
                self?.alpha = 0
            },
            completion: completion
        )
    }

    /// Used to override the default font on the callout
    ///
    /// - Parameters:
    ///   - font: font on the callout
    public func setFont(_ font: UIFont) {
        textLabel.font = font
    }

    // MARK: - Setup

    private func setup() {
        addSubview(boxView)
        addSubview(arrowView)
        addSubview(textLabel)

        arrowView.transform = arrowRotationTransformation

        let arrowConstraint: NSLayoutConstraint

        switch arrowAlignment {
        case .center:
            arrowConstraint = arrowView.centerXAnchor.constraint(equalTo: centerXAnchor)
        case .left(let value):
            arrowConstraint = arrowView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: value)
        case .right(let value):
            arrowConstraint = arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -value)
        }

        let defaultConstraints = [
            arrowView.widthAnchor.constraint(equalToConstant: 20),
            arrowView.heightAnchor.constraint(equalToConstant: 12),
            arrowConstraint,

            textLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: .spacingM),
            textLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: .spacingM),
            textLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -.spacingM),
            textLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -.spacingM)
        ]

        NSLayoutConstraint.activate(defaultConstraints + directionConstraints())
    }

    private func directionConstraints() -> [NSLayoutConstraint] {
        switch direction {
        case .up:
            return [
                arrowView.topAnchor.constraint(equalTo: topAnchor),
                boxView.topAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: -boxView.layer.borderWidth - 1),
                boxView.bottomAnchor.constraint(equalTo: bottomAnchor),
                boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
                boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        case .down:
            return [
                arrowView.bottomAnchor.constraint(equalTo: bottomAnchor),
                boxView.topAnchor.constraint(equalTo: topAnchor),
                boxView.bottomAnchor.constraint(equalTo: arrowView.topAnchor, constant: boxView.layer.borderWidth + 1),
                boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
                boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        }
    }

}

// MARK: - Private types

private final class ArrowView: UIView {

    private lazy var triangleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.fillColor = .bgSuccess
        layer.strokeColor = .accentPea
        return layer
    }()

    private lazy var bottomBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = .bgSuccess
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        layer.addSublayer(triangleLayer)
        layer.addSublayer(bottomBorderLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let path = CGMutablePath()
        let bottomBorderHeight: CGFloat = 1
        let pathHeight = rect.maxY - bottomBorderHeight
        let point1 = CGPoint(x: rect.minX, y: pathHeight)
        let point2 = CGPoint(x: rect.midX, y: rect.minY)
        let point3 = CGPoint(x: rect.maxX, y: pathHeight)
        let radius: CGFloat = 2

        path.move(to: point1)
        path.addArc(tangent1End: point1, tangent2End: point2, radius: radius)
        path.addArc(tangent1End: point2, tangent2End: point3, radius: radius)
        path.addLine(to: CGPoint(x: rect.maxX, y: pathHeight))

        triangleLayer.path = path
        bottomBorderLayer.frame = CGRect(x: rect.minX, y: pathHeight, width: rect.width, height: bottomBorderHeight)
    }
}
