import UIKit

enum Orientation {
    case portrait
    case landscape
}

enum Device: String {
    case phone4inch = "iPhone 5S (4-inch)"

    // swiftlint:disable:next identifier_name
    case phone4_7inch = "iPhone 6 (4.7-inch)"

    // swiftlint:disable:next identifier_name
    case phone5_5inch = "iPhone 6 Plus (5.5-inch)"

    // swiftlint:disable:next identifier_name
    case phone5_8inch = "iPhone X (5.8-inch)"

    // swiftlint:disable:next identifier_name
    case pad10_5 = "iPad (10.5-inch)"

    // swiftlint:disable:next identifier_name
    case pad12_9inch = "iPad (12.9-inch)"

    // swiftlint:disable:next large_tuple
    func dimensions(currentTraitCollection: UITraitCollection) -> (traits: UITraitCollection, frame: CGRect, autoresizingMask: UIView.AutoresizingMask) {
        let size: CGSize
        let horizontalSizeClass: UIUserInterfaceSizeClass
        let verticalSizeClass: UIUserInterfaceSizeClass
        let userInterfaceIdiom: UIUserInterfaceIdiom
        let autoresizingMask: UIView.AutoresizingMask
        let isPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown

        switch self {
        case .phone4inch, .phone4_7inch, .phone5_5inch, .phone5_8inch:
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .phone
            autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        case .pad10_5, .pad12_9inch:
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }

        switch self {
        case .phone4inch:
            size = .init(width: 320, height: 568)
        case .phone4_7inch:
            size = .init(width: 375, height: 667)
        case .phone5_5inch:
            size = .init(width: 414, height: 736)
        case .phone5_8inch:
            size = .init(width: 375, height: 812)
        case .pad10_5:
            size = isPortrait ? .init(width: 768, height: 1_024) : .init(width: 1_024, height: 768)
        case .pad12_9inch:
            size = isPortrait ? .init(width: 1_024, height: 1_366) : .init(width: 1_366, height: 1_024)
        }

        // swiftlint:disable:next identifier_name
        let x: CGFloat = (UIScreen.main.bounds.width - size.width) / 2

        // swiftlint:disable:next identifier_name
        let y: CGFloat = (UIScreen.main.bounds.height - size.height) / 2

        let traits: UITraitCollection = .init(traitsFrom: [
            .init(horizontalSizeClass: horizontalSizeClass),
            .init(verticalSizeClass: verticalSizeClass),
            .init(userInterfaceIdiom: userInterfaceIdiom)
            ])

        return (traits, CGRect(x: x, y: y, width: size.width, height: size.height), autoresizingMask: autoresizingMask)
    }

    static var all: [Device] {
        return [.phone4inch,
                .phone4_7inch,
                .phone5_5inch,
                .phone5_8inch,
                .pad10_5,
                .pad12_9inch]
    }
}
