//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class SplashView: UIView {
    private lazy var leftLogoView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .splashLogo)
        return imageView
    }()

    private lazy var rightLogoView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.clipsToBounds = true
        view.backgroundColor = .secondaryBlue
        view.layer.borderColor = .milk
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 4
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return view
    }()

    private lazy var letterViews: [UIView] = {
        let assets: [FinniversImageAsset] = [.splashLetters1, .splashLetters2, .splashLetters3, .splashLetters4]
        return assets.map {
            let imageView = UIImageView(withAutoLayout: true)
            imageView.image = UIImage(named: $0)
            imageView.alpha = 0
            return imageView
        }
    }()

    private lazy var leftLogoViewCenterXConstraint = leftLogoView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -25)
    private lazy var rightLogoViewWidthConstraint = rightLogoView.widthAnchor.constraint(equalToConstant: 50)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .secondaryBlue

        addSubview(leftLogoView)
        addSubview(rightLogoView)

        letterViews.forEach({ addSubview($0) })

        NSLayoutConstraint.activate([
            leftLogoViewCenterXConstraint,
            leftLogoView.centerYAnchor.constraint(equalTo: centerYAnchor),

            rightLogoView.leadingAnchor.constraint(equalTo: leftLogoView.trailingAnchor, constant: -1),
            rightLogoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLogoViewWidthConstraint,
            rightLogoView.heightAnchor.constraint(equalToConstant: 50),

            letterViews[0].leadingAnchor.constraint(equalTo: centerXAnchor, constant: -8),
            letterViews[0].bottomAnchor.constraint(equalTo: rightLogoView.bottomAnchor),

            letterViews[1].leadingAnchor.constraint(equalTo: letterViews[0].trailingAnchor, constant: 4),
            letterViews[1].bottomAnchor.constraint(equalTo: letterViews[0].bottomAnchor),

            letterViews[2].leadingAnchor.constraint(equalTo: letterViews[1].trailingAnchor, constant: 4),
            letterViews[2].bottomAnchor.constraint(equalTo: letterViews[0].bottomAnchor),

            letterViews[3].leadingAnchor.constraint(equalTo: letterViews[2].trailingAnchor, constant: 4),
            letterViews[3].bottomAnchor.constraint(equalTo: letterViews[0].bottomAnchor)
        ])
    }

    public func animate() {
        leftLogoViewCenterXConstraint.constant = -47
        rightLogoViewWidthConstraint.constant = 96

        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        var delay: TimeInterval = 0.1

        for letterView in letterViews {
            letterView.layer.add(makeLetterAnimation(withDelay: delay), forKey: nil)
            delay += 0.1
        }
    }

    private func makeLetterAnimation(withDelay delay: TimeInterval) -> CAAnimationGroup {
        let transform = CABasicAnimation(keyPath: "transform.translation.y")
        transform.toValue = -15
        transform.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let alpha = CABasicAnimation(keyPath: "opacity")
        alpha.toValue = 1

        let group = CAAnimationGroup()
        group.animations = [alpha, transform]
        group.beginTime = CACurrentMediaTime() + delay
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.duration = 0.3
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false

        return group
    }
}
