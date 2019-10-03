import FinniversKit

public enum DnaDemoViews: String, CaseIterable {
    case color
    case font
    case spacing
    case assets

    public static var items: [DnaDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .color:
            return DemoViewControllerContainer<ColorDemoView>()
        case .font:
            return DemoViewControllerContainer<FontDemoView>()
        case .spacing:
            return DemoViewControllerContainer<SpacingDemoView>()
        case .assets:
            return DemoViewControllerContainer<AssetsDemoView>()
        }
    }
}
