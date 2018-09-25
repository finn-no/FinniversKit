//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

final class DrumPadCollectionViewCell: UICollectionViewCell {
    private lazy var overlayLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.init(white: 1, alpha: 0.8).cgColor
        return layer
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.addSublayer(overlayLayer)
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        overlayLayer.frame = contentView.bounds
        overlayLayer.cornerRadius = contentView.layer.cornerRadius
    }

    // MARK: - Styles

    func flash(withDuration duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        contentView.layer.add(animation, forKey: nil)
    }

    func updateOverlayVisibility(isVisible: Bool) {
        overlayLayer.isHidden = !isVisible
    }

    private func setupStyles() {
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.white.cgColor
        updateOverlayVisibility(isVisible: false)
    }
}
