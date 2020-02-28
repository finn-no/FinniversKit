//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FavoriteButtonDemoView: UIView {
    private lazy var favoriteButton = FavoriteButtonView(withAutoLayout: true)
    private var isFavorited = false {
        didSet { favoriteButton.configure(isFavorited: isFavorited) }
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
        favoriteButton.configure(isFavorited: isFavorited)
        favoriteButton.delegate = self
        addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])

    }
}

extension FavoriteButtonDemoView: FavoriteButtonViewDelegate {
    func favoriteButtonDidSelect(_ button: FavoriteButtonView) {
        isFavorited.toggle()
    }
}

private extension FavoriteButtonView {
    func configure(isFavorited: Bool) {
        switch isFavorited {
        case true:
            configure(withTitle: "Lagt til som favoritt", subtitle: "123 456 har lagt til som favoritt", isFavorited: true)
        case false:
            configure(withTitle: "Legg til favoritt", subtitle: "123 456 har lagt til som favoritt", isFavorited: false)
        }
    }
}
