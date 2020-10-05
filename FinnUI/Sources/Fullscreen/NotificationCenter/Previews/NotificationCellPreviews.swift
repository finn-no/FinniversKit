//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//
import FinniversKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI

/// A generic UIViewRepresentable to present UIViews in Xcode previews, intended for DemoViews
struct DemoWrapperView<DemoView: UIView>: UIViewRepresentable {
    let view: DemoView

    init(view: DemoView) {
        self.view = view
    }

    func makeUIView(context: Context) -> DemoView { view }

    func updateUIView(_ uiView: DemoView, context: Context) {}
}

private struct DemoNotification: NotificationCellModel {
    var isRead: Bool = false
    var content: NotificationCellContent?

    struct SavedSearch: SavedSearchNotificationCellContent {
        var locationText: String
        var ribbonViewModel: RibbonViewModel?
        var imagePath: String?
        var title: String
        var priceText: String?
        var isFavorite: Bool
    }

    struct Personal: PersonalNotificationCellContent {
        var description: String
        var icon: PersonalNotificationIconView.Kind
        var imagePath: String?
        var title: String
        var priceText: String?
    }
}

private extension DemoNotification {
    static let savedSearchSold = DemoNotification(
        isRead: true,
        content: DemoNotification.SavedSearch(
            locationText: "Ranheim with a very long text for some reason",
            ribbonViewModel: RibbonViewModel(style: .warning, title: "Solg"),
            imagePath: nil,
            title: "Hvite joggesko selges",
            priceText: "150 kr",
            isFavorite: true
        )
    )

    static let savedSearchJob = DemoNotification(
        isRead: true,
        content: DemoNotification.SavedSearch(
            locationText: "Rådal | Cool Company",
            ribbonViewModel: nil,
            imagePath: nil,
            title: "Mekanisk / prossess ingeniør",
            priceText: nil,
            isFavorite: false
        )
    )

    static let personal = DemoNotification(
        isRead: false,
        content: Personal(
            description: "Din favoritt er satt ned i pris",
            icon: .favorite,
            imagePath: nil,
            title: "Nydelig beigegrå sofa i ull",
            priceText: "~1050~ 900 kr"
        )
    )
}

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct NotificationCellDemoView_Previews: PreviewProvider {
    static func cell(
        viewModel: NotificationCellModel = DemoNotification.savedSearchSold,
        timestamp: String = "4 min siden",
        hideSeparator: Bool = false,
        showGradient: Bool = false
    ) -> UIView {
        let cell = NotificationCell(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 120)))
        cell.configure(
            with: viewModel,
            timestamp: timestamp,
            hideSeparator: hideSeparator,
            showGradient: showGradient
        )
        return cell
    }

    static func previewCases(_ scheme: String) -> some View {
        Group {
            DemoWrapperView(view: cell())
                .previewDisplayName("Saved Search - Read - \(scheme)")

            DemoWrapperView(view: cell(viewModel: DemoNotification.savedSearchJob))
                .previewDisplayName("Saved Job - Read - \(scheme)")

            DemoWrapperView(view: cell(viewModel: DemoNotification.personal))
                .previewDisplayName("Personal - Unread - \(scheme)")
        }
    }

    static var previews: some View {
        Group {
            previewCases("Light")
            previewCases("Dark")
                .colorScheme(.dark)
        }
        .previewLayout(.fixed(width: 375, height: 120))
    }
}
#endif
