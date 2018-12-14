//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class NewYearsView: UIView {
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
        fireworksView.start()
        balloonView.animate(duration: duration) {
            self.fireworksView.stop()
        }
    }
}

private extension NewYearsView {
    func setup() {
        balloonView.imagePositions = [0.2, 0.4, 0.6, 0.8]
        balloonView.imageAssets = assets

        addSubview(fireworksView)
        fireworksView.fillInSuperview()
        addSubview(balloonView)
        balloonView.fillInSuperview()
    }
}
