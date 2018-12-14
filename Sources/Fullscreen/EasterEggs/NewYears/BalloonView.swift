//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class BalloonView: UIView {
    public var imagePositions: [CGFloat] = []
    public var imageAssets: [FinniversImageAsset] = [] {
        didSet { loadImages(assets: imageAssets) }
    }

    private var isAnimating = false
    private var imageViews: [UIImageView] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func animate(duration: Double, completion: @escaping () -> Void) {
        guard !isAnimating else { return }
        isAnimating = true
        imageViews.enumerated().forEach { (index, imageView) in
            imageView.frame.origin = CGPoint(x: self.imagePositions[index] * frame.width - imageView.frame.width / 2, y: frame.height)
            imageView.isHidden = false
        }

        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeLinear, animations: {
            self.imageViews.forEach { imageView in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: Double.random(in: 0.8 ... 1.0), animations: {
                    imageView.frame.origin.y = -imageView.frame.height
                })
            }
        }, completion: { _ in
            self.isAnimating = false
            completion()
        })
    }
}

private extension BalloonView {
    func loadImages(assets: [FinniversImageAsset]) {
        if !imageViews.isEmpty {
            imageViews.forEach { $0.removeFromSuperview() }
        }

        imageViews = assets.map { asset -> UIImageView in
            return UIImageView(image: UIImage(named: asset))
        }

        guard imageViews.count == imagePositions.count else { return }
        imageViews.forEach { imageView in
            let scale = CGFloat.random(in: 0.8 ... 1.0)
            imageView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            imageView.isHidden = true
            insertSubview(imageView, at: Int.random(in: 0 ..< imageViews.count))
        }
    }
}
