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

// MARK: - Private extensions

private extension FavoriteAdActionViewModel {
    static let `default` = FavoriteAdActionViewModel(
        headerImage: createImage(),
        headerTitle: "Ærverdig herskapelig villa, med praktfull beliggende strandtomt (6500 kvm), helt i vannkanten. Perle, finnes ikke maken!",
        commentText: "Legg til notat",
        shareText: "Del annonsen",
        deleteText: "Slett favoritten fra listen"
    )

    static func createImage() -> UIImage? {
        let urlString = "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg"

        guard let url = URL(string: urlString) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }

        return UIImage(data: data)
    }
}
