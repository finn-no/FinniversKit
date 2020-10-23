//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct SearchDisplayTypeSelectionViewModel {
    public let listText: String
    public let listIcon: UIImage
    public let gridText: String
    public let gridIcon: UIImage
    public let mapText: String
    public let mapIcon: UIImage

    // MARK: - Init

    public init(
        listText: String,
        listIcon: UIImage,
        gridText: String,
        gridIcon: UIImage,
        mapText: String,
        mapIcon: UIImage
    ) {
        self.listText = listText
        self.listIcon = listIcon
        self.gridText = gridText
        self.gridIcon = gridIcon
        self.mapText = mapText
        self.mapIcon = mapIcon
    }
}
