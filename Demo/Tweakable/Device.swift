import UIKit

enum Device: String {
    case phone4inch = "iPhone 5S (4-inch)"

    // swiftlint:disable:next identifier_name
    case phone4_7inch = "iPhone 6 (4.7-inch)"

    // swiftlint:disable:next identifier_name
    case phone5_5inch = "iPhone 6 Plus (5.5-inch)"

    // swiftlint:disable:next identifier_name
    case phone5_8inch = "iPhone X (5.8-inch)"

    case padPortraitOneThird = "iPad Portrait 1/3"

    case padPortraitTwoThirds = "iPad Portrait 2/3"

    case padPortraitFull = "iPad Portrait Full"

    case padLandscapeOneThird = "iPad Landscape 1/3"

    case padLandscapeOneHalf = "iPad Landscape 1/2"

    case padLandscapeTwoThirds = "iPad Landscape 2/3"

    case padLandscapeFull = "iPad Landscape Full"

    // swiftlint:disable:next large_tuple
    func dimensions(currentTraitCollection: UITraitCollection) -> (traits: UITraitCollection, frame: CGRect, autoresizingMask: UIView.AutoresizingMask) {
        let size: CGSize
        let horizontalSizeClass: UIUserInterfaceSizeClass
        let verticalSizeClass: UIUserInterfaceSizeClass
        let userInterfaceIdiom: UIUserInterfaceIdiom
        let autoresizingMask: UIView.AutoresizingMask

        switch self {
        case .phone4inch:
            size = .init(width: 320, height: 568)
        case .phone4_7inch:
            size = .init(width: 375, height: 667)
        case .phone5_5inch:
            size = .init(width: 414, height: 736)
        case .phone5_8inch:
            size = .init(width: 375, height: 812)
        case .padPortraitOneThird:
            size = .init(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height)
        case .padPortraitTwoThirds:
            size = .init(width: (UIScreen.main.bounds.width / 3) * 2, height: UIScreen.main.bounds.height)
        case .padPortraitFull:
            size = UIScreen.main.bounds.size
        case .padLandscapeOneThird:
            size = .init(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height)
        case .padLandscapeOneHalf:
            size = .init(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
        case .padLandscapeTwoThirds:
            size = .init(width: (UIScreen.main.bounds.width / 3) * 2, height: UIScreen.main.bounds.height)
        case .padLandscapeFull:
            size = UIScreen.main.bounds.size
        }

        // swiftlint:disable:next identifier_name
        var x: CGFloat = (UIScreen.main.bounds.width - size.width) / 2
        // swiftlint:disable:next identifier_name
        let y: CGFloat = (UIScreen.main.bounds.height - size.height) / 2

        switch self {
        case .phone4inch, .phone4_7inch, .phone5_5inch, .phone5_8inch:
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .phone
            autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        case .padLandscapeOneThird, .padLandscapeOneHalf, .padPortraitOneThird, .padPortraitTwoThirds:
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
            autoresizingMask = [.flexibleHeight]
            x = 0
        case .padPortraitFull, .padLandscapeFull, .padLandscapeTwoThirds:
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
            autoresizingMask = [.flexibleHeight, .flexibleWidth]
            x = 0
        }

        let traits: UITraitCollection = .init(traitsFrom: [
            .init(horizontalSizeClass: horizontalSizeClass),
            .init(verticalSizeClass: verticalSizeClass),
            .init(userInterfaceIdiom: userInterfaceIdiom)
            ])

        return (traits, CGRect(x: x, y: y, width: size.width, height: size.height), autoresizingMask: autoresizingMask)
    }

    static var all: [Device] {
        var devices: [Device] = [.phone4inch,
                .phone4_7inch,
                .phone5_5inch,
                .phone5_8inch]

        let isPortrait = UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .portraitUpsideDown
        if isPortrait {
            devices.append(contentsOf: [.padPortraitOneThird,
                                        .padPortraitTwoThirds,
                                        .padPortraitFull])
        } else {
            devices.append(contentsOf: [.padLandscapeOneThird,
                                        .padLandscapeOneHalf,
                                        .padLandscapeTwoThirds,
                                        .padLandscapeFull])
        }
        return devices
    }
}
