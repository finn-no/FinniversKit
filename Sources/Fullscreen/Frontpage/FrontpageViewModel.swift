//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FrontpageViewModel {
    public let frontpageViewDelegate: FrontpageViewDelegate?
    public let marketsGridViewDelegate: MarketsGridViewDelegate
    public let marketsGridViewDataSource: MarketsGridViewDataSource
    public let adsGridViewHeaderTitle: String
    public let adsGridViewDelegate: AdsGridViewDelegate
    public let adsGridViewDataSource: AdsGridViewDataSource
    public let retryButtonTitle: String
}
