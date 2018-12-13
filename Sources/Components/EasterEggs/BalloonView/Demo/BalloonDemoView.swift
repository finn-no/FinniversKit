//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

class BalloonDemoView: UIView {

    private let assets: [FinniversImageAsset] = [.balloon_2, .balloon_0, .balloon_1, .balloon_9]
    private lazy var balloonView = BalloonView(frame: UIScreen.main.bounds)

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
        balloonView.animate(duration: 10.0)
    }
}

private extension BalloonDemoView {
    func setup() {
        balloonView.imageAssets = assets
        addSubview(balloonView)
        balloonView.fillInSuperview()
    }
}
