import UIKit

public struct SparkleSection {
    var title: String
    var items: [SparkleItem]

    public init(title: String, items: [SparkleItem]) {
        self.title = title
        self.items = items
    }
}

public struct SparkleItem {
    var title: String
    var viewController: UIViewController

    public init(title: String, viewController: UIViewController) {
        self.title = title
        self.viewController = viewController
    }
}
