//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class NewYearsView: UIView {

    public var isAnimating = false

    private let assets: [FinniversImageAsset] = [.balloon2, .balloon0, .balloon1, .balloon9]
    private lazy var balloonView = BalloonView(frame: .zero)
    private lazy var fireworksView = FireworksView(frame: .zero)

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func startAnimation(duration: Double) {
        isAnimating = true
        fireworksView.start()
        balloonView.animate(duration: duration) { [weak self] in
            self?.fadeOut()
        }
    }
}

private extension NewYearsView {
    func fadeOut() {
        UIView.animate(withDuration: 2, animations: {
            self.alpha = 0
        }) { didComplete in
            self.fireworksView.stop()
            self.isAnimating = false
            self.isHidden = true
        }
    }

    func setup() {
        balloonView.imagePositions = [0.2, 0.4, 0.6, 0.8]
        balloonView.imageAssets = assets
        
        addSubview(fireworksView)
        fireworksView.fillInSuperview()
        addSubview(balloonView)
        balloonView.fillInSuperview()
    }
}
