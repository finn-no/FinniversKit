//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsViewCellModel {

    public let title: String
    public var stateText: String?
    public let hairline: Bool

    public init(title: String, stateText: String? = nil, hairline: Bool = true) {
        self.title = title
        self.stateText = stateText
        self.hairline = hairline
    }
}
