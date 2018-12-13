//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class BalloonView: UIView {

    public var imageAssets: [FinniversImageAsset] = [] {
        didSet { loadImages(assets: imageAssets) }
    }

    public var isAnimating = false

    private var imageViews: [UIImageView] = []
    private var topAnchors: [NSLayoutConstraint] = []
    private var leadingAnchors: [NSLayoutConstraint] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func animate(duration: Double) {
        guard !isAnimating else { return }
        isAnimating = true
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubic, animations: {
            self.imageViews.forEach({ imageView in
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: Double.random(in: 0.8 ... 1.0), animations: {
                    imageView.frame.origin.y = -imageView.frame.height
                })
            })
        }, completion: { _ in
            self.isAnimating = false
        })
    }
}

private extension BalloonView {
    func loadImages(assets: [FinniversImageAsset]) {
        superview?.layoutIfNeeded()
        if !imageViews.isEmpty {
            imageViews.forEach { $0.removeFromSuperview() }
        }

        imageViews = assets.map({ asset -> UIImageView in
            return UIImageView(image: UIImage(named: asset))
        })
        
        imageViews.enumerated().forEach { (index, imageView) in
            let scale = CGFloat.random(in: 0.8 ... 1.0)
            imageView.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
            imageView.frame.origin = CGPoint(x: 32 + CGFloat(index) * 68, y: frame.height)
            addSubview(imageView)
        }
    }
}
