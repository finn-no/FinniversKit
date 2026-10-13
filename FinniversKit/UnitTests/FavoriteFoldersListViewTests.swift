//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@preconcurrency import FinniversKit
import Testing
import UIKit

@Suite("FavoriteFoldersListView Tests")
@MainActor
final class FavoriteFoldersListViewTests {
    private var hostingWindows: [UIWindow] = []

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

    @Test("First visible item view skips the add folder row")
    func firstVisibleItemViewSkipsAddFolderRow() {
        let view = makeHostedView(dataSource: DataSource(numberOfItems: 3), isAddButtonHidden: false)

        let itemView = view.firstFullyVisibleItemView()

        view.performUpdates { context in
            let indexPath = (itemView as? UITableViewCell).flatMap { context.tableView.indexPath(for: $0) }
            #expect(indexPath == IndexPath(row: 0, section: context.section))
        }
    }

    @Test("First visible item view honours the row filter")
    func firstVisibleItemViewHonoursRowFilter() {
        let view = makeHostedView(dataSource: DataSource(numberOfItems: 3), isAddButtonHidden: true)

        let itemView = view.firstFullyVisibleItemView { $0 > 0 }

        view.performUpdates { context in
            let indexPath = (itemView as? UITableViewCell).flatMap { context.tableView.indexPath(for: $0) }
            #expect(indexPath == IndexPath(row: 1, section: context.section))
        }
    }

    @Test("First visible item view is nil while editing")
    func firstVisibleItemViewIsNilWhileEditing() {
        let view = makeHostedView(dataSource: DataSource(numberOfItems: 3), isAddButtonHidden: true)

        view.setEditing(true)

        #expect(view.firstFullyVisibleItemView() == nil)
    }

    @Test("First visible item view is nil for an empty list")
    func firstVisibleItemViewIsNilForEmptyList() {
        let view = makeHostedView(dataSource: DataSource(numberOfItems: 0), isAddButtonHidden: true)

        #expect(view.firstFullyVisibleItemView() == nil)
    }

    private func makeHostedView(
        dataSource: DataSource,
        isAddButtonHidden: Bool
    ) -> FavoriteFoldersListView {
        let viewModel = FavoriteFoldersListViewModel(
            searchBarPlaceholder: "Search",
            addFolderText: "Add folder",
            emptyViewBodyPrefix: "No folders",
            isEditable: true
        )
        let view = FavoriteFoldersListView(viewModel: viewModel)
        view.dataSource = dataSource
        view.isAddButtonHidden = isAddButtonHidden
        view.isSearchBarHidden = true
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        view.frame = window.bounds
        window.addSubview(view)
        window.isHidden = false
        view.reloadData()
        view.layoutIfNeeded()
        hostingWindows.append(window)
        return view
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
