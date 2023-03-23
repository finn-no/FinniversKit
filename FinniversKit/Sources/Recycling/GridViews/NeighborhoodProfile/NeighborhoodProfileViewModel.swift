//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct NeighborhoodProfileViewModel {
    public let title: String
    public let readMoreLink: Link?
    public let cards: [Card]
    public let banner: Banner?

    public init(title: String, readMoreLink: Link?, cards: [Card], banner: Banner?) {
        self.title = title
        self.readMoreLink = readMoreLink
        self.cards = cards
        self.banner = banner
    }
}

// MARK: - Types

extension NeighborhoodProfileViewModel {
    public enum Card {
        case info(content: Content, rows: [Row])
        case button(content: Content)
    }
    
    public struct Banner {
        public let text: String
        public let link: Link
        public let iconName: String
    
        public init(text: String, link: Link, iconName: String) {
            self.text = text
            self.link = link
            self.iconName = iconName
        }
    }

    public struct Content {
        public let title: String
        public let link: Link?
        public let icon: UIImage?

        public init(title: String, link: Link? = nil, icon: UIImage? = nil) {
            self.title = title
            self.link = link
            self.icon = icon
        }
    }

    public struct Row {
        public let title: String
        public let detailText: String?
        public let icon: UIImage?
        public let accessibilityLabel: String?

        public init(title: String, detailText: String? = nil, icon: UIImage? = nil, accessibilityLabel: String? = nil) {
            self.title = title
            self.detailText = detailText
            self.icon = icon
            self.accessibilityLabel = accessibilityLabel
        }
    }

    public struct Link {
        public let title: String
        public let url: URL?

        public init(title: String, url: URL?) {
            self.title = title
            self.url = url
        }
    }
}
