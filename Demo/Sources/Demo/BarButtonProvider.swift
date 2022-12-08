import UIKit

protocol BarButtonProvider: UIView {
    var rightBarButtonItems: [UIBarButtonItem] { get }
}
