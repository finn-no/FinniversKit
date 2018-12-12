//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import AVFoundation

public class SnowGlobeView: UIView {
    private lazy var emitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterCells = [emitterCell]
        layer.emitterShape = .line
        layer.renderMode = .oldestLast
        layer.lifetime = 0
        return layer
    }()

    private lazy var gradientLayer: CALayer = {
        let layer = CAGradientLayer()
        let color = UIColor(r: 0, g: 98, b: 255, a: 0.2) ?? UIColor.black.withAlphaComponent(0.2)
        layer.colors = [UIColor.clear.cgColor, color.cgColor, color.cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0, 0.1, 0.9, 1.0]
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

    private lazy var audioPlayer: AVAudioPlayer? = {
        let url = Bundle.finniversKit.url(forResource: "sleighbell", withExtension: "mp3")
        let player = url.flatMap({ try? AVAudioPlayer(contentsOf: $0) })
        player?.volume = 0.8
        return player
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
        stop(animated: false)
    }

    // MARK: - Animation

    public func start(animated: Bool) {
        guard !isAnimating else {
            return
        }

        audioPlayer?.play()
        let duration = (audioPlayer?.duration ?? 9) - 2

        updateLayersVisibility(isVisible: true, animated: animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.updateLayersVisibility(isVisible: false, animated: animated)
        }
    }

    public func stop(animated: Bool) {
        audioPlayer?.stop()
        updateLayersVisibility(isVisible: false, animated: animated)
    }

    private func updateLayersVisibility(isVisible: Bool, animated: Bool) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = isVisible ? 0.0 : 1.0
        animation.toValue = isVisible ? 1.0 : 0.0
        animation.duration = animated ? 2.0 : 0.0
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        let animationKey = "fade"
        layer.removeAnimation(forKey: animationKey)
        layer.add(animation, forKey: animationKey)
        emitterLayer.lifetime = isVisible ? 1 : 0
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

        emitterLayer.frame = bounds
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: bounds.height)
        emitterLayer.position = CGPoint(x: bounds.width, y: bounds.height / 2)
    }

    private func setup() {
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = false

        layer.opacity = 0
        layer.addSublayer(gradientLayer)
        layer.addSublayer(emitterLayer)

        audioPlayer?.prepareToPlay()
    }
}
