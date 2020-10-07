//
//  NotificationHeaderPreviews.swift
//  FinnUI
//
//  Created by Felipe Espinoza on 07/10/2020.
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import UIKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI

private struct HeaderPreviewModel: NotificationCenterHeaderViewModel {
    var title: String?
    var searchName: String?
    var count: Int?
    var includeMoreButton: Bool = true

    var savedSearchButtonModel: SavedSearchHeaderButtonModel? {
        guard let searchName = searchName else { return nil }
        let text: String
        if let count = count {
            text = "\(count) nye treff "
        } else {
            text = "Nytt treff i "
        }
        return SavedSearchHeaderButtonModel(
            text: text + searchName,
            highlightedRange: NSRange(location: text.count, length: searchName.count)
        )
    }
}

private extension HeaderPreviewModel {
    static let simpleTitle = HeaderPreviewModel(
        title: "Hello World",
        searchName: nil,
        count: 40,
        includeMoreButton: false
    )

    static let savedSearchDay = HeaderPreviewModel(
        title: "Hello World",
        searchName: "Sko",
        count: 40
    )

    static let savedSearchFlat = HeaderPreviewModel(
        title: nil,
        searchName: "Sko",
        count: 5
    )

    static let savedSearchFlatNoMore = HeaderPreviewModel(
        title: nil,
        searchName: "Sko",
        count: 5,
        includeMoreButton: false
    )

    static let savedSearchLongName = HeaderPreviewModel(
        title: nil,
        searchName: "This search has an extremely long name for some reason",
        count: 5
    )

    static let savedSearchNoCount = HeaderPreviewModel(
        title: nil,
        searchName: "Sko",
        count: nil
    )
}

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct NotificationCenterHeaderViewDemoView_Previews: PreviewProvider {
    private static func headerView(_ viewModel: HeaderPreviewModel = .simpleTitle) -> UIView {
        let view = NotificationCenterHeaderView(reuseIdentifier: "preview")
        view.translatesAutoresizingMaskIntoConstraints = true
        view.configure(with: viewModel, inSection: 1)
        view.layoutIfNeeded()
        return view
    }

    static var previews: some View {
        Group {
            DemoWrapperView(view: headerView())

            DemoWrapperView(view: headerView(.savedSearchDay))

            DemoWrapperView(view: headerView(.savedSearchLongName))

            DemoWrapperView(view: headerView(.savedSearchFlat))

            DemoWrapperView(view: headerView(.savedSearchFlatNoMore))

            DemoWrapperView(view: headerView(.savedSearchNoCount))

            DemoWrapperView(view: headerView())
                .environment(\.colorScheme, ColorScheme.dark)
                .previewDisplayName("Dark")
                .background(Color.black)
        }
        .previewLayout(.fixed(width: 375, height: 80))
    }
}
#endif
