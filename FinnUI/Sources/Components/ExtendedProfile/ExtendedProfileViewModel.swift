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

    public init(
        headerImage: UIImage,
        headerBackgroundColor: UIColor,
        sloganText: String,
        sloganBackgroundColor: UIColor,
        sloganTextColor: UIColor
    ) {
        self.headerImage = headerImage
        self.headerBackgroundColor = headerBackgroundColor
        self.sloganText = sloganText
        self.sloganBackgroundColor = sloganBackgroundColor
        self.sloganTextColor = sloganTextColor
    }
}
