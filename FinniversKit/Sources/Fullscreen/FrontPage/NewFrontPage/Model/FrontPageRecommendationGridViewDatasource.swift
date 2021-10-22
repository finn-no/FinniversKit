//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation
import UIKit

public protocol FrontPageRecommendationGridViewDatasource {
    func frontPageRecommendationGrid(heightForItemWithWidth: CGFloat, at indexPath: IndexPath) -> CGFloat
    func getAllGridElementHeights(forWidth width: CGFloat) -> [CGFloat]
    func frontPageRecommendationGrid(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell?
    func frontPageRecommendationGrid(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type]
    func frontPageRecommendationGrid(sectionFor sectionIndex: Int) -> NewFrontPageView.Section
    func snapshotForDatasource() -> NewFrontPageView.Snapshot
}
