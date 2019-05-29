//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class IconCollectionDemoView: UIView {
    private lazy var collectionView = IconCollectionView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .milk
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: .mediumSpacing),
            collectionView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
        ])

        collectionView.configure(with: [
            IconCollectionViewModel(title: "0-2 soverom", image: UIImage(named: .iconRealestateBedrooms)),
            IconCollectionViewModel(title: "Leilighet, Enebolig, Rekkehus", image: UIImage(named: .iconRealestateApartments)),
            IconCollectionViewModel(title: "Pris kommer", image: UIImage(named: .iconRealestatePrice)),
            IconCollectionViewModel(title: "Eier (Selveier)", image: UIImage(named: .iconRealestateOwner))
        ])
    }
}
