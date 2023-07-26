import FinniversKit
import DemoKit

enum DNA: String, CaseIterable, DemoGroup, DemoGroupItem {
    case color
    case font
    case spacing

    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .color:
            return ColorDemoView()
        case .font:
            return FontDemoView()
        case .spacing:
            return SpacingDemoView()
        }
    }
}
