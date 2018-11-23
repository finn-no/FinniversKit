//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FrontPageViewModel {
    var adsGridViewHeaderTitle: String { get }
    var retryButtonTitle: String { get }
    var noRecommendationsText: String { get }
    var inlineConsentYesButtonTitle: String { get }
    var inlineConsentInfoButtonTitle: String { get }
}
