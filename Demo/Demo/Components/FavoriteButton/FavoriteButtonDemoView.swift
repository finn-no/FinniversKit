//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FavoriteButtonDemoView: UIView {

    // MARK: - Private properties

    private lazy var favoriteButtonView = FavoriteButtonView(withAutoLayout: true)
    private lazy var data = FavoriteButtonData(isFavorite: false)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        favoriteButtonView.configure(with: data)
        favoriteButtonView.delegate = self
        addSubview(favoriteButtonView)

        NSLayoutConstraint.activate([
            favoriteButtonView.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            favoriteButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

// MARK: - FavoriteButtonViewDelegate

extension FavoriteButtonDemoView: FavoriteButtonViewDelegate {
    func favoriteButtonDidSelect(_ favoriteButtonView: FavoriteButtonView, button: Button, viewModel: FavoriteButtonViewModel) {
        data.isFavorite.toggle()
        favoriteButtonView.configure(with: data)
    }
}
