//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class CalloutView: UIView {
    private lazy var boxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .mint
        view.layer.borderColor = .pea
        view.layer.borderWidth = 2
        view.layer.cornerRadius = .mediumSpacing
        return view
    }()

    private lazy var arrowView: UIView = {
        let view = ArrowView(withAutoLayout: true)
        view.backgroundColor = .clear
        //view.backgroundColor = .mint
        //view.layer.borderColor = .pea
        //view.layer.borderWidth = 2
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont(name: FontType.bold.rawValue, size: 16.0)?.scaledFont(forTextStyle: .callout)
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

    }

    // MARK: - Setup

    public func show(withText text: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 2
        paragraph.alignment = .center

        textLabel.attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraph])

        alpha = 1
        transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil
        )
    }

    public func hide() {
        alpha = 0
    }

    private func setup() {
        addSubview(boxView)
        addSubview(arrowView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            arrowView.topAnchor.constraint(equalTo: topAnchor),
            arrowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 20),
            arrowView.heightAnchor.constraint(equalToConstant: 12),

            boxView.topAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: -boxView.layer.borderWidth - 1),
            boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boxView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: .mediumLargeSpacing),
            textLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -.mediumLargeSpacing),
            textLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}

// MARK: - Private types

private final class ArrowView: UIView {
    private lazy var triangleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.fillColor = .mint
        layer.strokeColor = .pea
        return layer
    }()

    private lazy var bottomBorderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = .mint
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
