//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteActionDemoView: UIView {
    private(set) lazy var view: FavoriteActionView = {
        let view = FavoriteActionView(viewModel: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
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

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteActionDemoView: FavoriteActionViewDelegate {
    func favoriteActionView(_ view: FavoriteActionView, didSelectAction action: FavoriteAction) {
        print("\(action) selected")
    }
}
