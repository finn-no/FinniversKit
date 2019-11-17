import UIKit

public struct SandboxSection {
    var title: String
    var items: [SandboxItem]

    public init(title: String, items: [SandboxItem]) {
        self.title = title
        self.items = items
    }
}

public struct SandboxItem {
    var title: String
    var viewController: UIViewController

    public init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}
