//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

class BalloonDemoView: UIView {

    private let assets: [FinniversImageAsset] = [.balloon_2, .balloon_0, .balloon_1, .balloon_9]
    private lazy var balloonView = BalloonView(frame: .zero)
    private lazy var fireworksView = FireworksView(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        fireworksView.start()
        balloonView.animate(duration: 10.0) {
            self.fireworksView.stop()
        }
    }
}

private extension BalloonDemoView {
    func setup() {
        balloonView.imagePositions = [0.2, 0.4, 0.6, 0.8]
        balloonView.imageAssets = assets
        
        addSubview(fireworksView)
        fireworksView.fillInSuperview()
        addSubview(balloonView)
        balloonView.fillInSuperview()
    }
}
