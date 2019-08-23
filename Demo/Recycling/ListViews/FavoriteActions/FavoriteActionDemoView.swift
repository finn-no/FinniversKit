//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFolderActionDemoView: UIView {
    private(set) lazy var view: FavoriteFolderActionsListView = {
        let view = FavoriteFolderActionsListView(viewModel: .default)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteFolderActionDemoView: FavoriteFolderActionsListViewDelegate {
    func favoriteFolderActionsListView(_ view: FavoriteFolderActionsListView, didSelectAction action: FavoriteFolderAction) {
        print("\(action) selected")

        switch action {
        case .share:
            view.isCopyLinkHidden.toggle()
        default:
            break
        }
    }
}
