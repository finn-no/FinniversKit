//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class IconCollectionDemoView: UIView {
    private lazy var iconCollectionView = IconCollectionView(withAutoLayout: true)

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
        addSubview(iconCollectionView)
        iconCollectionView.fillInSuperview()

        iconCollectionView.configure(with: [
            IconCollectionViewModel(title: "0-2 soverom", image: UIImage(named: .iconRealestateBebrooms)),
            IconCollectionViewModel(title: "Leiligheter", image: UIImage(named: .iconRealestateApartments)),
            IconCollectionViewModel(title: "Pris kommer", image: UIImage(named: .iconRealestatePrice)),
            IconCollectionViewModel(title: "Eier (Selveier)", image: UIImage(named: .iconRealestateOwner))
        ])
    }
}
