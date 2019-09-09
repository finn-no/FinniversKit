//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteAdActionDemoView: UIView {
    private(set) lazy var view: FavoriteAdActionView = {
        let view = FavoriteAdActionView(viewModel: .default)
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

// MARK: - FavoriteAdActionViewDelegate

extension FavoriteAdActionDemoView: FavoriteAdActionViewDelegate {
    func favoriteAdActionView(_ view: FavoriteAdActionView, didSelectAction action: FavoriteAdAction) {
        print("\(action) selected")
    }
}
