//
//  ChristmasPromotionCellDemoView.swift
//

import UIKit
import FinniversKit

public class ChristmasPromotionCellDemoView: UIView {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 28, height: 130)
        layout.sectionInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChristmasPromotionCell.self, forCellWithReuseIdentifier: ChristmasPromotionCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .bgPrimary
        return collectionView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup
extension ChristmasPromotionCellDemoView {
    private func setup() {
        addSubview(collectionView)
        collectionView.fillInSuperview()
        collectionView.reloadData()
    }
}

//MARK: - CollectionView DataSource
extension ChristmasPromotionCellDemoView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ChristmasPromotionCell.self, for: indexPath)
        cell.delegate = self
        return cell
    }
}

extension ChristmasPromotionCellDemoView: PromotionCellDelegate {
    public func didSelectItem(_ promotionCell: ChristmasPromotionCell) {
        print("Promotion got selected")
    }
}
