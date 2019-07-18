import UIKit

struct TweakingOption {
    var title: String
    var description: String?
    var action: ((_ parentViewController: UIViewController?) -> Void)
}
