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
    case pad10_5 = "iPad (10.5-inch)"

    // swiftlint:disable:next identifier_name
    case pad12_9inch = "iPad (12.9-inch)"

    func dimensions(orientation: Orientation) -> (traits: UITraitCollection, frame: CGRect) {
        let size: CGSize
        let horizontalSizeClass: UIUserInterfaceSizeClass
        let verticalSizeClass: UIUserInterfaceSizeClass
        let userInterfaceIdiom: UIUserInterfaceIdiom
        switch (self, orientation) {
        case (.phone4inch, .portrait):
            size = .init(width: 320, height: 568)
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .phone
        case (.phone4inch, .landscape):
            size = .init(width: 568, height: 320)
            horizontalSizeClass = .compact
            verticalSizeClass = .compact
            userInterfaceIdiom = .phone
        case (.phone4_7inch, .portrait):
            size = .init(width: 375, height: 667)
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .phone
        case (.phone4_7inch, .landscape):
            size = .init(width: 667, height: 375)
            horizontalSizeClass = .compact
            verticalSizeClass = .compact
            userInterfaceIdiom = .phone
        case (.phone5_5inch, .portrait):
            size = .init(width: 414, height: 736)
            horizontalSizeClass = .compact
            verticalSizeClass = .regular
            userInterfaceIdiom = .phone
        case (.phone5_5inch, .landscape):
            size = .init(width: 736, height: 414)
            horizontalSizeClass = .regular
            verticalSizeClass = .compact
            userInterfaceIdiom = .phone
        case (.pad10_5, .portrait):
            size = .init(width: 768, height: 1_024)
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
        case (.pad10_5, .landscape):
            size = .init(width: 1_024, height: 768)
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
        case (.pad12_9inch, .portrait):
            size = .init(width: 1_024, height: 1_366)
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
        case (.pad12_9inch, .landscape):
            size = .init(width: 1_366, height: 1_024)
            horizontalSizeClass = .regular
            verticalSizeClass = .regular
            userInterfaceIdiom = .pad
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

        return (traits, CGRect(x: x, y: y, width: size.width, height: size.height))
    }

    static var all: [Device] {
        return [.phone4inch,
                .phone4_7inch,
                .phone5_5inch,
                .pad10_5,
                .pad12_9inch]
    }
}
