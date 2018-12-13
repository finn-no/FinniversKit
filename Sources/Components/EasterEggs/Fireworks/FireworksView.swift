//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class FireworksView: UIView {

    let emitterLayer = CAEmitterLayer()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FireworksView {
    func setup() {
        superview?.layoutIfNeeded()
        emitterLayer.emitterPosition = CGPoint(x: frame.width / 2, y: frame.height)

        let baseCell = CAEmitterCell()
        baseCell.birthRate = 1 / 2
        baseCell.emissionLongitude = -.pi / 2
        baseCell.lifetime = 1.5 + 2
        baseCell.velocity = 300

        let rocketCell = CAEmitterCell()
        rocketCell.color = UIColor.orange.cgColor
        rocketCell.birthRate = 200
        rocketCell.lifetime = 0.3
        rocketCell.alphaSpeed = -1.0 / 0.3
        rocketCell.velocity = 0
        rocketCell.velocityRange = 50
        rocketCell.scale = 0.07
        rocketCell.scaleSpeed = -0.07 / 0.3
        rocketCell.emissionRange = 2 * .pi
        rocketCell.contents = UIImage(named: .spark).cgImage
        rocketCell.duration = 1.5

        let explosionCell = CAEmitterCell()
        explosionCell.color = UIColor.red.cgColor
        explosionCell.birthRate = 10000
        explosionCell.lifetime = 2.0
        explosionCell.alphaSpeed = -1.0 / 2.0
        explosionCell.velocity = 100
        explosionCell.velocityRange = 50
        explosionCell.scale = 0.1
        explosionCell.scaleSpeed = -0.1 / 2.0
        explosionCell.emissionRange = 2 * .pi
        explosionCell.yAcceleration = 100
        explosionCell.contents = UIImage(named: .spark).cgImage
        explosionCell.beginTime = 1.5
        explosionCell.duration = 0.1

        baseCell.emitterCells = [rocketCell, explosionCell]
        emitterLayer.emitterCells = [baseCell]
        emitterLayer.renderMode = .additive
        layer.addSublayer(emitterLayer)
    }
}
