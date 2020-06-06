//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public class ConfettiView: UIView {

    private lazy var confettiImages: [UIImage] = [
        .init(named: .confetti1),
        .init(named: .confetti2)
    ]

    private lazy var confettiColors: [UIColor] = [
        .primaryBlue,
        .secondaryBlue,
        .pea,
        .watermelon
    ]

    private let numberOfCells = 10

    private lazy var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterShape = .line
        layer.lifetime = 1

        layer.emitterCells = (0..<16).map {
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

        cell.birthRate = 2.5
        cell.lifetime = 10
        cell.lifetimeRange = 2

        cell.contents = confettiImages.randomElement()?.cgImage
        cell.color = color.cgColor

        cell.emissionLongitude = CGFloat.pi

        cell.velocity = CGFloat.random(in: 2...5)

        cell.yAcceleration = CGFloat.random(in: 40...60)
        cell.xAcceleration = CGFloat.random(in: -10...10)

        cell.scale = 0.2
        cell.scaleRange = 0.1

        cell.spin = CGFloat.pi
        cell.spinRange = 0.5

        return cell
    }

}
