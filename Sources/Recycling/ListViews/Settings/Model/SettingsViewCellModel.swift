//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsViewCellModel {

    public let title: String
    public var status: String?
    public let hairline: Bool

    public init(title: String, status: String? = nil, hairline: Bool = true) {
        self.title = title
        self.status = status
        self.hairline = hairline
    }
}
