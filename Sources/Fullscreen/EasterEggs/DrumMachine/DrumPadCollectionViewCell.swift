//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class DrumPadCollectionViewCell: UICollectionViewCell {
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.8)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(overlayView)
        setupStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        overlayView.frame = contentView.bounds
    }

    // MARK: - Styles

    func flash(withDuration duration: TimeInterval) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0.5
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        contentView.layer.add(animation, forKey: nil)
    }

    func updateOverlayVisibility(isVisible: Bool) {
        overlayView.isHidden = !isVisible
    }

    private func setupStyles() {
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.white.cgColor
        updateOverlayVisibility(isVisible: false)
    }
}
