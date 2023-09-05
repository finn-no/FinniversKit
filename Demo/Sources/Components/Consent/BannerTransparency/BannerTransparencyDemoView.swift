//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class BannerTransparencyDemoView: UIView, Demoable {
    var presentation: DemoablePresentation { .sheet(detents: [.medium(), .large()]) }

    private lazy var bannerTranparencyView = BannerTransparencyView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(bannerTranparencyView)
        bannerTranparencyView.fillInSuperview()
        bannerTranparencyView.model = BannerTransparencyInfoDefaultData()
    }
}
