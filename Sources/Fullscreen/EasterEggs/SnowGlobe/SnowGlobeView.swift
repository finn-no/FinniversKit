//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
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

    private lazy var topGradientLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.locations = [0.0, 0.7]
        layer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.3).cgColor]
        return layer
    }()

    private lazy var bottomGradientLayer: CALayer = {
        let layer = CAGradientLayer()
        layer.locations = [0.0, 0.7]
        layer.colors = [UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.clear.cgColor]
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
        let player = soundUrl.flatMap({ try? AVAudioPlayer(contentsOf: $0) })
        player?.delegate = self
        player?.volume = 0.8
        return player
    }()

    private var soundUrl: URL? {
        return Bundle.finniversKit.url(forResource: "sleighbell", withExtension: "mp3")
    }

    private var isAnimating: Bool {
        return emitterLayer.lifetime != 0
    }

    public override var canBecomeFirstResponder: Bool {
        return true
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
        start(animated: false)
    }

    // MARK: - Motion

    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if event?.subtype == .motionShake {
            start(animated: true)
        }
    }

    // MARK: - Animation

    public func start(animated: Bool) {
        guard !isAnimating else {
            return
        }

        audioPlayer?.play()
        updateLayersVisibility(isVisible: true, animated: animated)
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
        let halfHeight = bounds.height / 2
        topGradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: halfHeight)
        bottomGradientLayer.frame = CGRect(x: 0, y: halfHeight, width: bounds.width, height: halfHeight)

        emitterLayer.frame = bounds
        emitterLayer.emitterSize = CGSize(width: bounds.width, height: bounds.height)
        emitterLayer.position = CGPoint(x: bounds.width, y: bounds.height / 2)
    }

    private func setup() {
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isUserInteractionEnabled = false

        layer.opacity = 0
        layer.addSublayer(topGradientLayer)
        layer.addSublayer(bottomGradientLayer)
        layer.addSublayer(emitterLayer)

        audioPlayer?.prepareToPlay()
    }
}

// MARK: - AVAudioPlayerDelegate

extension SnowGlobeView: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        guard isAnimating else {
            return
        }
        updateLayersVisibility(isVisible: false, animated: true)
    }
}
