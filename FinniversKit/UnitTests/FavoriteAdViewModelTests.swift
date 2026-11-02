//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@preconcurrency import FinniversKit
import Testing
import UIKit
import Warp

@Suite("FavoriteAdViewModel status badge")
struct FavoriteAdViewModelTests {
    @Test("The status badge initializer keeps every Warp badge variant", arguments: Warp.BadgeVariant.allCases)
    func statusBadgeInitializerKeepsVariant(variant: Warp.BadgeVariant) {
        let statusBadge = FavoriteAdViewModel.StatusBadge(text: "Solgt", variant: variant)

        let viewModel = makeViewModel(statusBadge: statusBadge)

        #expect(viewModel.statusBadge == statusBadge)
        #expect(viewModel.ribbonViewModel == nil)
    }

    @Test(
        "The ribbon initializer converts the ribbon style to a badge variant",
        arguments: [
            (RibbonView.Style.default, Warp.BadgeVariant.neutral),
            (.success, .success),
            (.warning, .warning),
            (.error, .negative),
            (.disabled, .disabled),
            (.sponsored, .sponsored),
        ]
    )
    @available(*, deprecated)
    func ribbonInitializerConvertsStyle(style: RibbonView.Style, expectedVariant: Warp.BadgeVariant) {
        let ribbonViewModel = RibbonViewModel(style: style, title: "Aktiv")

        let viewModel = makeViewModel(ribbonViewModel: ribbonViewModel)

        #expect(viewModel.statusBadge == FavoriteAdViewModel.StatusBadge(text: "Aktiv", variant: expectedVariant))
        #expect(viewModel.ribbonViewModel == ribbonViewModel)
    }

    @Test("Without a status the view model has no badge")
    @available(*, deprecated)
    func noStatusGivesNoBadge() {
        #expect(makeViewModel(statusBadge: nil).statusBadge == nil)
        #expect(makeViewModel(ribbonViewModel: nil).statusBadge == nil)
    }

    // MARK: - Private

    private func makeViewModel(statusBadge: FavoriteAdViewModel.StatusBadge?) -> FavoriteAdViewModel {
        FavoriteAdViewModel(
            addressText: "Oslo",
            titleText: "Sofa",
            titleColor: .text,
            descriptionPrimaryText: nil,
            descriptionSecondaryText: nil,
            descriptionTertiaryText: nil,
            imagePath: nil,
            statusBadge: statusBadge,
            sortingDetailText: nil,
            addedToFolderDate: Date(timeIntervalSince1970: 0),
            lastUpdated: nil,
            comment: nil
        )
    }

    // Covers the deprecated initializer on purpose, it stays supported until consumers migrate.
    @available(*, deprecated)
    private func makeViewModel(ribbonViewModel: RibbonViewModel?) -> FavoriteAdViewModel {
        FavoriteAdViewModel(
            addressText: "Oslo",
            titleText: "Sofa",
            titleColor: .text,
            descriptionPrimaryText: nil,
            descriptionSecondaryText: nil,
            descriptionTertiaryText: nil,
            imagePath: nil,
            ribbonViewModel: ribbonViewModel,
            sortingDetailText: nil,
            addedToFolderDate: Date(timeIntervalSince1970: 0),
            lastUpdated: nil,
            comment: nil
        )
    }
}
