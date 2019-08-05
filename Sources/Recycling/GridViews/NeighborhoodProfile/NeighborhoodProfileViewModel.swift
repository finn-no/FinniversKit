//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

//swiftlint:disable nesting
public struct NeighborhoodProfileViewModel {
    public let title: String
    public let readMoreLinkText: String?
    public let readMoreLinkPath: String?
    public let cards: [Card]

    public init(title: String, readMoreLinkText: String, readMoreLinkPath: String, cards: [Card]) {
        self.title = title
        self.readMoreLinkText = readMoreLinkText
        self.readMoreLinkPath = readMoreLinkPath
        self.cards = cards
    }
}

// MARK: - Card

extension NeighborhoodProfileViewModel {
    public struct Card {
        public let title: String
        public let linkText: String
        public let linkPath: String
        public let kind: Kind

        public enum Kind {
            case pointOfIntereset([PointOfIntereset])
            case text([String])
            case noContent
            case button
        }

        public init(title: String, linkText: String, linkPath: String, kind: Kind) {
            self.title = title
            self.linkText = linkText
            self.linkPath = linkPath
            self.kind = kind
        }
    }
}

// MARK: - Point of intereset

extension NeighborhoodProfileViewModel {
    public struct PointOfIntereset {
        public enum DistanceType {
            case walk
            case drive
        }

        public let name: String
        public let distanceType: DistanceType
        public let distance: String

        public init(name: String, distanceType: DistanceType, distance: String) {
            self.name = name
            self.distanceType = distanceType
            self.distance = distance
        }
    }
}
