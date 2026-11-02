//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// Shows every ad status badge variant, including the price variant used for sold, given away, rented and bought ads.
final class FavoriteAdStatusBadgesDemoView: FavoriteAdCellDemoView {
    init() {
        super.init(viewModels: FavoriteAdsFactory.createStatusBadgeExamples())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
