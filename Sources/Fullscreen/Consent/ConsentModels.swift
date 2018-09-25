//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public struct ConsentDetailViewModel { 
    public let heading: String
    public let definition: String
    public let purpose: String
    
    public init(heading: String, definition: String, purpose: String) {
        self.heading = heading
        self.definition = definition
        self.purpose = purpose
    }
}
