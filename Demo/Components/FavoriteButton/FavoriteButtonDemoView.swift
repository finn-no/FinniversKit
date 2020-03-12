//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FavoriteButtonDemoView: UIView {
    private lazy var favoriteButtonView = FavoriteButtonView(withAutoLayout: true)
    private var data = FavoriteButtonData(isFavorite: false)
    private var isFavorite = false {
        didSet {
            data.isFavorite = isFavorite
            favoriteButtonView.configure(with: data)
        }
    }

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

extension FavoriteButtonDemoView: FavoriteButtonViewDelegate {
    func favoriteButtonDidSelect(_ favoriteButtonView: FavoriteButtonView, button: Button, viewModel: FavoriteButtonViewModel) {
        isFavorite.toggle()
    }
}
