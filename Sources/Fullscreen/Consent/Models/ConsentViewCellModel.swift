//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct ConsentViewCellModel {

    public let title: String
    public var stateText: String?
    public let hairLine: Bool

    public init(title: String, stateText: String? = nil, hairLine: Bool = true) {
        self.title = title
        self.stateText = stateText
        self.hairLine = hairLine
    }
}
