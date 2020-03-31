//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class AddressCardDemoView: UIView {
    private lazy var view: AddressCardView = {
        let view = AddressCardView(withAutoLayout: true)
        view.dropShadow(color: .black, opacity: 0.3, radius: 3)
        view.layer.cornerRadius = 16
        view.configure(with: AddressCardViewModel())
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
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - AddressCardViewDelegate

extension AddressCardDemoView: AddressCardViewDelegate {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView) {
        print("addressCardViewDidSelectCopyButton")
    }

    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView, sender: UIView) {
        print("addressCardViewDidSelectGetDirectionsButton")
    }
}

// MARK: - Demo data

private extension AddressCardViewModel {
    init() {
        self.init(
            title: "Møllerøya 32",
            subtitle: "7982 Bindalseidet",
            copyButtonTitle: "Kopier adresse",
            getDirectionsButtonTitle: "Åpne veibeskrivelse"
        )
    }
}
