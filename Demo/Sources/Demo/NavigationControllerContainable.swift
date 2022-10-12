import UIKit

protocol NavigationControllerContainable: UIView {
    var rightBarButtonItems: [UIBarButtonItem] { get }
}
