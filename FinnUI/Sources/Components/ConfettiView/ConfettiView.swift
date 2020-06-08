//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public class ConfettiView: UIView {

    private let confettiImages: [UIImage] = [
        .init(named: .confetti1),
        .init(named: .confetti2)
    ]

    private let confettiColors: [UIColor] = [
        .primaryBlue,
        .secondaryBlue,
        .pea,
        .watermelon
    ]

    private lazy var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterShape = .line
        layer.emitterCells = (0...8).map {
            let color = confettiColors[$0 % confettiColors.count]
            return getConfettiEmitterCell(withColor: color)
        }
        return layer
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2, y: -50)
    }

    public func start() {
        emitterLayer.lifetime = 1
        emitterLayer.birthRate = 0.5
        emitterLayer.beginTime = CACurrentMediaTime()

        layer.addSublayer(emitterLayer)
    }

    public func stop() {
        emitterLayer.lifetime = 0

        UIView.animate(withDuration: 2, animations: {
            self.alpha = 0
        }, completion: { [weak self] _ in
            self?.emitterLayer.removeFromSuperlayer()
            self?.alpha = 1
        })
    }

    private func setup() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    private func getConfettiEmitterCell(withColor color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()

        cell.birthRate = 5
        cell.lifetime = 10
        cell.lifetimeRange = 2

        cell.contents = confettiImages.randomElement()?.cgImage
        cell.color = color.cgColor

        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4

        cell.velocity = CGFloat.random(in: 50...100)

        cell.yAcceleration = CGFloat.random(in: 15...45)
        cell.xAcceleration = CGFloat.random(in: -4...4)

        cell.scale = 0.2
        cell.scaleRange = 0.05

        let spin: CGFloat = Float.random(in: 0...1) > 0.5 ? .pi : -.pi
        cell.spin = spin / 2
        cell.spinRange = 1

        return cell
    }

}
