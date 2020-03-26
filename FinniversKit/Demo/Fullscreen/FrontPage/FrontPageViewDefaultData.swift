//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct FrontpageViewDefaultData: FrontPageViewModel {
    public let adsGridViewHeaderTitle = "Anbefalinger"
    public let retryButtonTitle = "Prøv igjen"
    public let noRecommendationsText = "Vi klarte dessverre ikke å laste dine anbefalinger."
    public let inlineConsentDialogueViewModel: DialogueViewModel =  DialogueDefaultData()

    public init() {}
}
