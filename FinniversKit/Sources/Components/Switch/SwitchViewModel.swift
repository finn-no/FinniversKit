//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol SwitchViewModel {
    var title: String { get }
    var detail: String { get }
    var initialSwitchValue: Bool { get }
}

public struct SwitchViewDefaultModel: SwitchViewModel {
    public let title: String
    public let detail: String
    public let initialSwitchValue: Bool

    public init(title: String, detail: String, initialSwitchValue: Bool) {
        self.title = title
        self.detail = detail
        self.initialSwitchValue = initialSwitchValue
    }
}
