//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct AddressCardViewModel {
    public let title: String
    public let subtitle: String
    public let copyButtonTitle: String
    public let getDirectionsButtonTitle: String

    public init(
        title: String,
        subtitle: String,
        copyButtonTitle: String,
        getDirectionsButtonTitle: String
    ) {
        self.title = title
        self.subtitle = subtitle
        self.copyButtonTitle = copyButtonTitle
        self.getDirectionsButtonTitle = getDirectionsButtonTitle
    }
}
