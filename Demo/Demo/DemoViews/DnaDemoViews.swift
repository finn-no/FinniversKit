import FinniversKit
import Sandbox

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
            return DemoViewController<ColorDemoView>()
        case .font:
            return DemoViewController<FontDemoView>()
        case .spacing:
            return DemoViewController<SpacingDemoView>()
        case .assets:
            return DemoViewController<AssetsDemoView>()
        }
    }
}
