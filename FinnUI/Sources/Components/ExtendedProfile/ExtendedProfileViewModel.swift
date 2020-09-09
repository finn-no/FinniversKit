//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct ExtendedProfileViewModel {

    public let headerImageUrl: String?
    public let footerImageUrl: String?

    public let sloganText: String?
    public let linkTitles: [String]
    public let actionButtonTitle: String?

    public let sloganTextColor: UIColor
    public let sloganBackgroundColor: UIColor
    public let mainTextColor: UIColor
    public let mainBackgroundColor: UIColor
    public let actionButtonTextColor: UIColor?
    public let actionButtonBackgroundColor: UIColor?

    public init(
        headerImageUrl: String?,
        footerImageUrl: String?,
        sloganText: String?,
        linkTitles: [String],
        actionButtonTitle: String?,
        sloganTextColor: UIColor,
        sloganBackgroundColor: UIColor,
        mainTextColor: UIColor,
        mainBackgroundColor: UIColor,
        actionButtonTextColor: UIColor?,
        actionButtonBackgroundColor: UIColor?
    ) {
        self.headerImageUrl = headerImageUrl
        self.footerImageUrl = footerImageUrl
        self.sloganText = sloganText
        self.linkTitles = linkTitles
        self.actionButtonTitle = actionButtonTitle
        self.sloganTextColor = sloganTextColor
        self.sloganBackgroundColor = sloganBackgroundColor
        self.mainTextColor = mainTextColor
        self.mainBackgroundColor = mainBackgroundColor
        self.actionButtonTextColor = actionButtonTextColor
        self.actionButtonBackgroundColor = actionButtonBackgroundColor
    }
}
