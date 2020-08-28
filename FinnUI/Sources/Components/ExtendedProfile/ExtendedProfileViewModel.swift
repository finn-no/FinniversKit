//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct ExtendedProfileViewModel {
    public let headerImage: UIImage
    public let headerBackgroundColor: UIColor

    public let sloganText: String
    public let sloganBackgroundColor: UIColor
    public let sloganTextColor: UIColor

    public let expandableViewBackgroundColor: UIColor

    public let actionButtonTitle: String

    public init(
        headerImage: UIImage,
        headerBackgroundColor: UIColor,
        sloganText: String,
        sloganBackgroundColor: UIColor,
        sloganTextColor: UIColor,
        expandableViewBackgroundColor: UIColor,
        actionButtonTitle: String
    ) {
        self.headerImage = headerImage
        self.headerBackgroundColor = headerBackgroundColor
        self.sloganText = sloganText
        self.sloganBackgroundColor = sloganBackgroundColor
        self.sloganTextColor = sloganTextColor
        self.expandableViewBackgroundColor = expandableViewBackgroundColor
        self.actionButtonTitle = actionButtonTitle
    }
}
