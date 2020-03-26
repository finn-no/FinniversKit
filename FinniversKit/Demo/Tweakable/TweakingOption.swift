import UIKit

struct TweakingOption {
    var title: String
    var description: String?
    var action: ((() -> Void)?)

    init(title: String, description: String? = nil, action: ((() -> Void))? = nil) {
        self.title = title
        self.description = description
        self.action = action
    }
}
