//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Foundation

public struct NotificationGroup: NotificationsGroupListViewModel {
    public var attributedTitle: NSAttributedString
    public var timeAgo: String
    public var footerAction: String
    public var notifications: [NotificationsListViewModel]
}

/// A model confirming to the NotificationsListViewModel protocol for showcasing NotificationsListViewCell in playground.
public struct Notification: NotificationsListViewModel {
    public var imagePath: String?
    public var imageSize: CGSize
    public var detail: String
    public var title: String
    public var price: String

    public var accessibilityLabel: String {
        var message = detail
        message += ". " + title
        message += ". Pris: kroner " + price
        return message
    }
}

/// Creates Notifications
public struct NotificationFactory {
    private struct ImageSource {
        let path: String
        let size: CGSize
    }

    public static func create(numberOfGroups: Int) -> [NotificationGroup] {
        return (0 ..< numberOfGroups).map { _ in
            var notifications = [Notification]()
            for notificationIndex in 0 ... 3 {
                let imageSource = imageSources[notificationIndex]
                let detail = details[notificationIndex]
                let title = titles[notificationIndex]
                notifications.append(Notification(imagePath: imageSource.path, imageSize: imageSource.size, detail: detail, title: title, price: price))
            }

            let groupTitleIndex = Int(arc4random_uniform(UInt32(NotificationFactory.groupTitles.count)))
            let groupTitle = groupTitles[groupTitleIndex]
            let stringValue = "Nye treff i \"\(groupTitle)\""
            let attributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColor(color: .primaryBlue, forText: "\"\(groupTitle)\"")

            let footerAction = "Viser 100 av \(notifications.count) nye annonser"
            return NotificationGroup(attributedTitle: attributedString, timeAgo: "\(groupTitleIndex + 10) m siden", footerAction: footerAction, notifications: notifications)
        }
    }

    private static var groupTitles: [String] {
        return [
            "Biler i norge",
            "Sogn og Fjordane+Møre og Romsdal+Nordland+Treff",
            "Aston Martin",
        ]
    }

    private static var details: [String] {
        return [
            "Oslo • Privat",
            "Drammen • Bedrift",
            "Lillestrom • Privat",
            "Tønsberg • Privat",
            "Bærum • Privat",
            "Lillehammer • Privat",
            "Oslo • Privat",
            "Tønsberg • Privat",
            "Bærum • Privat",
        ]
    }

    private static var titles: [String] {
        return [
            "Home Sweet Home Home Sweet Home Home Sweet Home Home Sweet Home Home Sweet Home",
            "Hjemmekjært",
            "Mansion",
            "Villa Medusa",
            "Villa Villekulla",
            "Privat slott",
            "Pent brukt bolig",
            "Enebolig i rolig strøk",
            "Hus til slags",
        ]
    }

    private static var price: String {
        let thousands = Int(arc4random_uniform(UInt32(99)))
        return "\(thousands) 000 000,-"
    }

    private static var randomImageSource: ImageSource {
        let random = Int(arc4random_uniform(UInt32(imageSources.count)))
        return imageSources[random]
    }

    private static var imageSources: [ImageSource] {
        return [
            ImageSource(path: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg", size: CGSize(width: 450, height: 354)),
            ImageSource(path: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg", size: CGSize(width: 800, height: 600)),
            ImageSource(path: "http://jonvilma.com/images/house-6.jpg", size: CGSize(width: 992, height: 546)),
            ImageSource(path: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg", size: CGSize(width: 736, height: 566)),
            ImageSource(path: "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg", size: CGSize(width: 550, height: 734)),
            ImageSource(path: "https://www.tumbleweedhouses.com/wp-content/uploads/tumbleweed-tiny-house-cypress-black-roof-hp.jpg", size: CGSize(width: 1000, height: 672)),
            ImageSource(path: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg", size: CGSize(width: 1200, height: 800)),
            ImageSource(path: "http://www.discoverydreamhomes.com/wp-content/uploads/Model-Features-Copper-House.jpg", size: CGSize(width: 1000, height: 563)),
            ImageSource(path: "https://i.pinimg.com/736x/72/14/22/721422aa64cbb51ccb5f02eb29c22255--gray-houses-colored-doors-on-houses.jpg", size: CGSize(width: 640, height: 799)),
            ImageSource(path: "https://i.pinimg.com/736x/38/f2/02/38f2028c5956cd6b33bfd16441a05961--victorian-homes-stone-victorian-house.jpg", size: CGSize(width: 523, height: 640)),
            ImageSource(path: "https://www.younghouselove.com/wp-content/uploads//2017/04/Beach-House-Update-Three-Houses-One-Pink.jpg", size: CGSize(width: 1500, height: 1125)),
        ]
    }
}

extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
        let range: NSRange = mutableString.range(of: stringValue, options: .caseInsensitive)
        addAttribute(.foregroundColor, value: color, range: range)
        addAttribute(.font, value: UIFont.title5, range: range)
    }
}
