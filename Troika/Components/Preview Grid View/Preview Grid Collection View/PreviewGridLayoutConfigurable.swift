import Foundation

protocol PreviewGridLayoutConfigurable {
    var topOffset: CGFloat { get }
    var sidePadding: CGFloat { get }
    var lineSpacing: CGFloat { get }
    var columnSpacing: CGFloat { get }
    var numberOfColumns: Int { get }
}

extension PreviewGridLayoutConfigurable {
    var lineSpacing: CGFloat {
        return columnSpacing
    }

    var columnSpacing: CGFloat {
        return 8.0
    }
}

struct PreviewGridLayoutIPhoneSmall: PreviewGridLayoutConfigurable {
    let topOffset: CGFloat = 5.0
    let sidePadding: CGFloat = 10.0
    let lineSpacing: CGFloat = 0.0
    let columnSpacing: CGFloat = 2.0
    let numberOfColumns: Int = 2
}

struct PreviewGridLayoutIPhone: PreviewGridLayoutConfigurable {
    let topOffset: CGFloat = 5.0
    let sidePadding: CGFloat = 15.0
    let numberOfColumns: Int = 2
}

struct PreviewGridLayoutIPad: PreviewGridLayoutConfigurable {
    let topOffset: CGFloat = 10.0
    let sidePadding: CGFloat = 25.0
    let columnSpacing: CGFloat = 5.0

    var numberOfColumns: Int {
        let isLandscape = UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)
        return isLandscape ? 6 : 5
    }
}
