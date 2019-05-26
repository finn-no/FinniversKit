//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class IconCollectionView: UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModels: [IconCollectionViewModel]) {

    }

    private func setup() {
        backgroundColor = .ice
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}
