//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class FireworksView: UIView {
    private var positions: [CGFloat] = [0.25, 0.5, 0.8]
    private var emitterLayers: [CAEmitterLayer] = []
    private let rocketLifetime: Float = 0.3
    private let rocketDuration: Float = 1.5
    private let explosionLifetime: Float = 2.0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func start() {
        emitterLayers.enumerated().forEach {
            $1.emitterPosition = CGPoint(x: frame.width * positions[$0], y: frame.height)
            $1.birthRate = Float.random(in: 0.3 ... 0.6)
        }
    }

    public func stop() {
        emitterLayers.forEach { $0.birthRate = 0 }
    }
}

private extension FireworksView {
    func setup() {
        superview?.layoutIfNeeded()
        emitterLayers.append(fireworksLayer())
        emitterLayers.append(fireworksLayer())
        emitterLayers.append(fireworksLayer())
        emitterLayers.forEach { layer.addSublayer($0) }
    }

    func fireworksLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()

        let baseCell = CAEmitterCell()
        baseCell.birthRate = 1.0
        baseCell.emissionLongitude = -.pi / 2
        baseCell.lifetime = rocketDuration + explosionLifetime
        baseCell.velocity = 300
        baseCell.velocityRange = 100
        baseCell.color = UIColor(white: 0.5, alpha: 0.5).cgColor
        baseCell.redRange = 0.9
        baseCell.greenRange = 0.9
        baseCell.blueRange = 0.9

        let rocketCell = CAEmitterCell()
        rocketCell.birthRate = 200
        rocketCell.lifetime = rocketLifetime
        rocketCell.alphaSpeed = -0.5 / rocketLifetime
        rocketCell.velocity = 0
        rocketCell.velocityRange = 50
        rocketCell.scale = 0.07
        rocketCell.scaleSpeed = -0.07 / CGFloat(rocketLifetime)
        rocketCell.emissionRange = 2 * .pi
        rocketCell.contents = UIImage(named: .spark).cgImage
        rocketCell.duration = Double(rocketDuration)

        let explosionCell = CAEmitterCell()
        explosionCell.birthRate = 500
        explosionCell.lifetime = explosionLifetime
        explosionCell.alphaSpeed = -0.5 / explosionLifetime
        explosionCell.velocity = 100
        explosionCell.velocityRange = 50
        explosionCell.scale = 0.1
        explosionCell.scaleSpeed = -0.1 / CGFloat(explosionLifetime)
        explosionCell.emissionRange = 2 * .pi
        explosionCell.yAcceleration = 100
        explosionCell.beginTime = 1.5
        explosionCell.duration = 0.1

        let flareCell = CAEmitterCell()
        flareCell.birthRate = 50
        flareCell.lifetime = explosionLifetime
        flareCell.velocity = 0
        flareCell.velocityRange = 20
        flareCell.alphaSpeed = -0.5 / explosionLifetime
        flareCell.emissionRange = 2 * .pi
        flareCell.yAcceleration = 5
        flareCell.contents = UIImage(named: .spark).cgImage
        flareCell.duration = Double(explosionLifetime)

        explosionCell.emitterCells = [flareCell]
        baseCell.emitterCells = [rocketCell, explosionCell]
        emitterLayer.emitterCells = [baseCell]
        emitterLayer.renderMode = .unordered
        return emitterLayer
    }
}
