//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox

public class SnowGlobeView: UIView {
    private lazy var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterCells = [emitterCell]
        layer.emitterShape = .line
        layer.renderMode = .oldestLast
        layer.lifetime = 0
        return layer
    }()

    private lazy var backgroundLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.opacity = 0.5
        return layer
    }()

    private lazy var emitterCell: CAEmitterCell = {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: .snowflake).cgImage
        cell.lifetime = 30
        cell.birthRate = 70
        cell.velocity = -280
        cell.velocityRange = -60.0
        cell.scale = 0.25
        cell.scaleRange = 0.75
        cell.spin = 0
        cell.spinRange = 2
        return cell
    }()

    private lazy var sound: SystemSoundID? = {
        guard let soundURL = Bundle.finniversKit.url(forResource: "sleighbell", withExtension: "mp3") else {
            return nil
        }

        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        return sound
    }()

    private var isAnimating: Bool {
        return emitterLayer.lifetime != 0
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    deinit {
        stopAnimating()
    }

    // MARK: - Animation

    public func startAnimating() {
        guard !isAnimating else {
            return
        }

        if let sound = sound {
            AudioServicesPlaySystemSound(sound)
        }

        emitterLayer.lifetime = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.emitterLayer.lifetime = 0
        }
    }

    public func stopAnimating() {
        emitterLayer.lifetime = 0
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        emitterLayer.frame = bounds
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: bounds.size.height)
        emitterLayer.position = CGPoint(x: bounds.size.width, y: bounds.size.height / 2)
    }

    private func setup() {
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = false

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(emitterLayer)
    }
}
