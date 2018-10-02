//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct ConsentDetailViewModel {
    public let switchTitle: String
    public let definition: String
    public let indexPath: IndexPath

    public init(heading: String, definition: String, indexPath: IndexPath) {
        self.switchTitle = heading
        self.definition = definition
        self.indexPath = indexPath
    }
}
