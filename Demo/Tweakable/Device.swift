import UIKit

struct Device {
    enum `Type`: String {
        case phone4inch = "iPhone 5S (4-inch)"

        // swiftlint:disable:next identifier_name
        case phone4_7inch = "iPhone 8 (4.7-inch)"

        // swiftlint:disable:next identifier_name
        case phone5_5inch = "iPhone 8 Plus (5.5-inch)"

        // swiftlint:disable:next identifier_name
        case phone5_8inch = "iPhone X (5.8-inch)"

        case padPortraitOneThird = "iPad Portrait 1/3"

        case padPortraitTwoThirds = "iPad Portrait 2/3"

        case padPortraitFull = "iPad Portrait Full"

        case padLandscapeOneThird = "iPad Landscape 1/3"

        case padLandscapeOneHalf = "iPad Landscape 1/2"

        case padLandscapeTwoThirds = "iPad Landscape 2/3"

        case padLandscapeFull = "iPad Landscape Full"
    }

    var type: Type
    var traits: UITraitCollection
    var frame: CGRect
    var autoresizingMask: UIView.AutoresizingMask
    var title: String {
        return type.rawValue
    }
    var isEnabled: Bool {
        switch type {
        case .phone4inch, .phone4_7inch, .phone5_5inch, .phone5_8inch:
            let currentSize = UIScreen.main.bounds.size
            return frame.width <= currentSize.width && frame.height <= currentSize.height
        case .padLandscapeOneThird, .padLandscapeOneHalf, .padPortraitOneThird, .padPortraitTwoThirds, .padPortraitFull, .padLandscapeFull, .padLandscapeTwoThirds:
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }

    // swiftlint:disable:next cyclomatic_complexity
    init(type: Type) {
        let size: CGSize
        let horizontalSizeClass: UIUserInterfaceSizeClass
        let verticalSizeClass = UIUserInterfaceSizeClass.regular
        let userInterfaceIdiom: UIUserInterfaceIdiom
        let autoresizingMask: UIView.AutoresizingMask

        switch type {
        case .phone4inch:
            size = .init(width: 320, height: 568)
        case .phone4_7inch:
            size = .init(width: 375, height: 667)
        case .phone5_5inch:
            size = .init(width: 414, height: 736)
        case .phone5_8inch:
            size = .init(width: 375, height: 812)
        case .padPortraitOneThird:
            size = .init(width: 320, height: UIScreen.main.bounds.height)
        case .padPortraitTwoThirds:
            size = .init(width: UIScreen.main.bounds.width - 320, height: UIScreen.main.bounds.height)
        case .padPortraitFull:
            size = UIScreen.main.bounds.size
        case .padLandscapeOneThird:
            size = .init(width: 320, height: UIScreen.main.bounds.height)
        case .padLandscapeOneHalf:
            size = .init(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
        case .padLandscapeTwoThirds:
            size = .init(width: UIScreen.main.bounds.width - 320, height: UIScreen.main.bounds.height)
        case .padLandscapeFull:
            size = UIScreen.main.bounds.size
        }

        // swiftlint:disable:next identifier_name
        var x: CGFloat = (UIScreen.main.bounds.width - size.width) / 2
        // swiftlint:disable:next identifier_name
        let y: CGFloat = (UIScreen.main.bounds.height - size.height) / 2

        switch type {
        case .phone4inch, .phone4_7inch, .phone5_5inch, .phone5_8inch:
            horizontalSizeClass = .compact
            userInterfaceIdiom = .phone
            autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin, .flexibleBottomMargin]
        case .padLandscapeOneThird, .padLandscapeOneHalf, .padPortraitOneThird, .padPortraitTwoThirds:
            horizontalSizeClass = .compact
            userInterfaceIdiom = .pad
            autoresizingMask = [.flexibleHeight]
            x = 0
        case .padPortraitFull, .padLandscapeFull, .padLandscapeTwoThirds:
            horizontalSizeClass = .regular
            userInterfaceIdiom = .pad
            autoresizingMask = [.flexibleHeight, .flexibleWidth]
            x = 0
        }

        let traits: UITraitCollection = .init(traitsFrom: [
            .init(horizontalSizeClass: horizontalSizeClass),
            .init(verticalSizeClass: verticalSizeClass),
            .init(userInterfaceIdiom: userInterfaceIdiom)
            ])

        self.type = type
        self.traits = traits
        self.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
        self.autoresizingMask = autoresizingMask
    }

    static var all: [Device] {
        var devices: [Device] = [
            Device(type: .phone4inch),
            Device(type: .phone4_7inch),
            Device(type: .phone5_5inch),
            Device(type: .phone5_8inch)
        ]

        let isPortrait = UIDevice.current.userInterfaceIdiom == .pad && UIScreen.main.bounds.size.height > UIScreen.main.bounds.size.width
        if isPortrait {
            devices.append(contentsOf: [Device(type: .padPortraitOneThird),
                                        Device(type: .padPortraitTwoThirds),
                                        Device(type: .padPortraitFull)])
        } else {
            devices.append(contentsOf: [Device(type: .padLandscapeOneThird),
                                        Device(type: .padLandscapeOneHalf),
                                        Device(type: .padLandscapeTwoThirds),
                                        Device(type: .padLandscapeFull)])
        }
        return devices
    }
}
