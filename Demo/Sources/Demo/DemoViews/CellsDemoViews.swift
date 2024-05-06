//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

enum CellsDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case basicCell
    case basicCellVariations
    case checkboxCell
    case checkboxSubtitleCell
    case radioButtonCell
    case heartSubtitleCell
    case iconTitleCell
    case remoteImageCell
    case favoriteAdCell
    case hostingContentConfigurationCell

    static var groupTitle: String { "Cells" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .basicCell:
            return BasicCellDemoView()
        case .basicCellVariations:
            return BasicCellVariationsDemoView()
        case .checkboxCell:
            return CheckboxCellDemoView()
        case .checkboxSubtitleCell:
            return CheckboxSubtitleCellDemoView()
        case .radioButtonCell:
            return RadioButtonCellDemoView()
        case .heartSubtitleCell:
            return HeartSubtitleCellDemoView()
        case .iconTitleCell:
            return IconTitleCellDemoView()
        case .remoteImageCell:
            return RemoteImageCellDemoView()
        case .favoriteAdCell:
            return FavoriteAdCellDemoView()
        case .hostingContentConfigurationCell:
            return HostingContentConfigurationCellDemoViewController()
        }
    }
}
