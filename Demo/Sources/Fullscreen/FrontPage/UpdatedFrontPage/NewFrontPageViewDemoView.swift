//
//  NewFrontPageViewDemoView.swift
//  Demo
//

import FinniversKit

public class NewFrontPageDemoView: UIView {
    
    private let ads: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 10)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        return ads
    }()
    
    private let favorites: [FavoritedShelfViewModel] = {
        FavoritedShelfFactory.create()
    }()
    
    private let savedSearches: [RecentlySavedViewModel] = {
        [
            RecentlySavedViewModel(id: "1", title: "Elektronisk"),
            RecentlySavedViewModel(id: "2", title: "Katter"),
            RecentlySavedViewModel(id: "3", title: "Hunder"),
            RecentlySavedViewModel(id: "4", title: "Klær"),
            RecentlySavedViewModel(id: "5", title: "Biler"),
        ]
         
    }()
    
    private lazy var frontPage: NewFrontPageView = {
        let view = NewFrontPageView(recommendationDatasource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(frontPage)
        frontPage.fillInSuperview()
    }
}

extension NewFrontPageDemoView: FrontPageRecommendationGridViewDatasource {
    public func getAllGridElementHeights(forWidth: CGFloat) -> [CGFloat] {
        ads.map { _ in 144 }
    }
    
    public func frontPageRecommendationGrid(sectionFor sectionIndex: Int) -> NewFrontPageView.Section {
        let section = NewFrontPageView.Section.allCases[sectionIndex]
        switch section {
        case .recentlySaved:
            if savedSearches.isEmpty { fallthrough }
            return .recentlySaved
        case .favorites:
            if favorites.isEmpty { fallthrough }
            return .favorites
        case .grid:
            return .grid
        }
    }
    
    
    public func frontPageRecommendationGrid(heightForItemWithWidth: CGFloat, at indexPath: IndexPath) -> CGFloat {
        144
    }
    
    public func frontPageRecommendationGrid(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell? {
        if let _ = item as? RecentlySavedViewModel {
            let cell = collectionView.dequeue(RecentlySavedCell.self, for: indexPath)
            return cell
        }
        
        if let _ = item as? FavoritedShelfViewModel {
            let cell = collectionView.dequeue(FrontpageFavoritedShelfItemCell.self, for: indexPath)
            let model = favorites[indexPath.item]
            cell.model = model
            return cell
        }
        
        if let ad = item as? Ad {
            switch ad.adType {
            case .google:
                return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)
            default:
                let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
                cell.configure(with: ad, atIndex: indexPath.item)
                return cell
            }
        }
        
        return nil
    }
    
    public func frontPageRecommendationGrid(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        [RecentlySavedCell.self, FrontpageFavoritedShelfItemCell.self, StandardAdRecommendationCell.self, BannerAdDemoCell.self]
    }
    
    public func snapshotForDatasource() -> NewFrontPageView.Snapshot {
        typealias SnapShot = NewFrontPageView.Snapshot
        typealias Section = NewFrontPageView.Section
        
        var snapshot = SnapShot()
        snapshot.appendSections([.recentlySaved])
        snapshot.appendItems(savedSearches)
        
        snapshot.appendSections([.favorites])
        snapshot.appendItems(favorites, toSection: .favorites)
        
        snapshot.appendSections([.grid])
        snapshot.appendItems(ads, toSection: .grid)
        
        return snapshot
    }
}
