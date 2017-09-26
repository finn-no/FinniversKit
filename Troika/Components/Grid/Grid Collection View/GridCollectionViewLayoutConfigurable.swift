import Foundation

protocol GridCollectionViewLayoutConfigurable {
    var topOffset: CGFloat { get }
    var sidePadding: CGFloat { get }
    var lineSpacing: CGFloat { get }
    var columnSpacing: CGFloat { get }
    var numberOfColumns: Int { get }
}

extension GridCollectionViewLayoutConfigurable {
    var lineSpacing: CGFloat {
        return columnSpacing
    }

    var columnSpacing: CGFloat {
        return 8.0
    }

    var nonImageHeightForItems: CGFloat {
        return  60.0
    }
}

struct GridCollectionViewLayoutIPhoneSmall: GridCollectionViewLayoutConfigurable {
    let topOffset: CGFloat = 5.0
    let sidePadding: CGFloat = 10.0
    let lineSpacing: CGFloat = 0.0
    let columnSpacing: CGFloat = 2.0
    let numberOfColumns: Int = 2
}

struct GridCollectionViewLayoutIPhone: GridCollectionViewLayoutConfigurable {
    let topOffset: CGFloat = 5.0
    let sidePadding: CGFloat = 15.0
    let numberOfColumns: Int = 2
}

struct GridCollectionViewLayoutIPad: GridCollectionViewLayoutConfigurable {
    let topOffset: CGFloat = 10.0
    let sidePadding: CGFloat = 25.0
    let columnSpacing: CGFloat = 5.0

    var numberOfColumns: Int {
        let isLandscape = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        return isLandscape ? 6 : 5
    }
}
