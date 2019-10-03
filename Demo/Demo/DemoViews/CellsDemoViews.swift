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
            return DemoViewControllerContainer<BasicCellDemoView>(dismissType: .dismissButton)
        case .basicCellVariations:
            return DemoViewControllerContainer<BasicCellVariationsDemoView>(dismissType: .dismissButton)
        case .checkboxCell:
            return DemoViewControllerContainer<CheckboxCellDemoView>(dismissType: .dismissButton)
        case .checkboxSubtitleCell:
            return DemoViewControllerContainer<CheckboxSubtitleCellDemoView>(dismissType: .dismissButton)
        case .radioButtonCell:
            return DemoViewControllerContainer<RadioButtonCellDemoView>(dismissType: .dismissButton)
        case .heartSubtitleCell:
            return DemoViewControllerContainer<HeartSubtitleCellDemoView>(dismissType: .dismissButton)
        case .iconTitleCell:
            return DemoViewControllerContainer<IconTitleCellDemoView>(dismissType: .dismissButton)
        case .remoteImageCell:
            return DemoViewControllerContainer<RemoteImageCellDemoView>(dismissType: .dismissButton)
        case .favoriteAdCell:
            return DemoViewControllerContainer<FavoriteAdCellDemoView>(dismissType: .dismissButton)
        }
    }
}
