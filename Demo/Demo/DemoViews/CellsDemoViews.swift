//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum CellsDemoViews: String, CaseIterable {
    case basicCell
    case basicCellVariations
    case checkboxCell
    case checkboxSubtitleCell
    case radioButtonCell
    case heartSubtitleCell
    case iconTitleCell
    case remoteImageCell
    case favoriteAdCell

    public static var items: [CellsDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .basicCell:
            return DemoViewController<BasicCellDemoView>(dismissType: .dismissButton)
        case .basicCellVariations:
            return DemoViewController<BasicCellVariationsDemoView>(dismissType: .dismissButton)
        case .checkboxCell:
            return DemoViewController<CheckboxCellDemoView>(dismissType: .dismissButton)
        case .checkboxSubtitleCell:
            return DemoViewController<CheckboxSubtitleCellDemoView>(dismissType: .dismissButton)
        case .radioButtonCell:
            return DemoViewController<RadioButtonCellDemoView>(dismissType: .dismissButton)
        case .heartSubtitleCell:
            return DemoViewController<HeartSubtitleCellDemoView>(dismissType: .dismissButton)
        case .iconTitleCell:
            return DemoViewController<IconTitleCellDemoView>(dismissType: .dismissButton)
        case .remoteImageCell:
            return DemoViewController<RemoteImageCellDemoView>(dismissType: .dismissButton)
        case .favoriteAdCell:
            return DemoViewController<FavoriteAdCellDemoView>(dismissType: .dismissButton)
        }
    }
}
