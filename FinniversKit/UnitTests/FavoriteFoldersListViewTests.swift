//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@preconcurrency import FinniversKit
import Testing
import UIKit

@Suite("FavoriteFoldersListView Tests")
@MainActor
struct FavoriteFoldersListViewTests {
    @Test("Entering edit mode keeps the hidden add section empty")
    func enteringEditModeWithHiddenAddButton() {
        let dataSource = DataSource(numberOfItems: 1)
        let view = makeView(dataSource: dataSource)

        view.setEditing(true)

        view.performUpdates { context in
            #expect(context.tableView.isEditing)
            #expect(context.tableView.numberOfRows(inSection: 0) == 0)
        }
    }

    @Test("Leaving edit mode keeps the hidden add section empty")
    func leavingEditModeWithHiddenAddButton() {
        let dataSource = DataSource(numberOfItems: 0)
        let view = makeView(dataSource: dataSource)
        view.setEditing(true)

        view.setEditing(false)

        view.performUpdates { context in
            #expect(!context.tableView.isEditing)
            #expect(context.tableView.numberOfRows(inSection: 0) == 0)
        }
    }

    private func makeView(dataSource: DataSource) -> FavoriteFoldersListView {
        let viewModel = FavoriteFoldersListViewModel(
            searchBarPlaceholder: "Search",
            addFolderText: "Add folder",
            emptyViewBodyPrefix: "No folders",
            isEditable: true
        )
        let view = FavoriteFoldersListView(viewModel: viewModel)
        view.dataSource = dataSource
        view.isAddButtonHidden = true
        view.reloadData()
        return view
    }
}

private final class DataSource: FavoriteFoldersListViewDataSource {
    private let numberOfItems: Int

    init(numberOfItems: Int) {
        self.numberOfItems = numberOfItems
    }

    func numberOfItems(inFavoriteFoldersListView view: FavoriteFoldersListView) -> Int {
        numberOfItems
    }

    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        viewModelAtIndex index: Int
    ) -> FavoriteFolderViewModel {
        FolderViewModel()
    }

    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping @Sendable (UIImage?) -> Void
    ) {
        completion(nil)
    }

    func favoriteFoldersListView(
        _ view: FavoriteFoldersListView,
        cancelLoadingImageWithPath imagePath: String,
        imageWidth: CGFloat
    ) {}
}

private struct FolderViewModel: FavoriteFolderViewModel {
    let title = "Folder"
    let subtitle: String? = nil
    let detailText: String? = nil
    let hasChevron = false
    let imagePath: String? = nil
    let cornerRadius: CGFloat = 0
    let imageViewWidth: CGFloat = 40
    let isSelected = false
    let isDefault = false
}
