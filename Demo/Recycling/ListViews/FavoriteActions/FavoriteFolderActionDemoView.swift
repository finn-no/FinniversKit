//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFolderActionDemoView: UIView {
    private(set) lazy var view: FavoriteFolderActionView = {
        let view = FavoriteFolderActionView(viewModel: .default)
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

extension FavoriteFolderActionDemoView: FavoriteFolderActionViewDelegate {
    func favoriteFolderActionView(_ view: FavoriteFolderActionView, didSelectAction action: FavoriteFolderAction) {
        print("\(action) selected")

        switch action {
        case .share:
            view.isCopyLinkHidden.toggle()
        default:
            break
        }
    }
}
