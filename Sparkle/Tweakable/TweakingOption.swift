import UIKit

public struct TweakingOption {
    var title: String
    var description: String?
    public var action: ((() -> Void)?)

    public init(title: String, description: String? = nil, action: ((() -> Void))? = nil) {
        self.title = title
        self.description = description
        self.action = action
    }
}
