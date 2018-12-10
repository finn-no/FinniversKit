//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class BannerTransparencyDemoView: UIView {
    private lazy var bannerTranparencyView = BannerTransparencyView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(bannerTranparencyView)
        bannerTranparencyView.fillInSuperview()
    }
}
