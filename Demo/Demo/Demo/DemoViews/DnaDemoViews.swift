import FinniversKit

public enum DnaDemoViews: String, DemoViews {
    case color
    case font
    case spacing
    case assets

    public var viewController: UIViewController {
        switch self {
        case .color:
            return DemoViewController<ColorDemoView>()
        case .font:
            return DemoViewController<FontDemoView>()
        case .spacing:
            return DemoViewController<SpacingDemoView>()
        case .assets:
            return UINavigationController(rootViewController: AssetsDemoViewController())
        }
    }
}
