//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol SwitchViewModel {
    var headerText: String { get }
    var onDescriptionText: String { get }
    var offDescriptionText: String { get }
}

public struct SwitchViewDefaultModel: SwitchViewModel {
    public let headerText: String
    public let onDescriptionText: String
    public let offDescriptionText: String

    public init(headerText: String, onDescriptionText: String, offDescriptionText: String) {
        self.headerText = headerText
        self.onDescriptionText = onDescriptionText
        self.offDescriptionText = offDescriptionText
    }
}
