//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//
import FinnUI
import FinniversKit

struct SavedSearchAdData: SavedSearchNotificationCellContent {
    let imagePath: String?
    var locationText: String
    let title: String
    var priceText: String?
    let ribbonViewModel: RibbonViewModel?
}

struct PersonalAdData: PersonalNotificationCellContent {
    let imagePath: String?
    let description: String
    let title: String
    let priceText: String?
    let icon: PersonalNotificationIconView.Kind
}

struct NotificationCenterItem: NotificationCellModel {
    var isRead: Bool
    var content: NotificationCellContent?
}

struct NotificationCenterSection: NotificationCenterHeaderViewModel {
    let title: String?
    let count: Int?
    let searchName: String?
    var items: [NotificationCenterCellType]

    var savedSearchButtonModel: SavedSearchHeaderButtonModel? {
        guard let searchName = searchName else { return nil }
        let text: String
        if let count = count {
            text = "\(count) nye treff "
        } else {
            text = "Nytt treff i "
        }
        return SavedSearchHeaderButtonModel(
            text: text + searchName,
            highlightedRange: NSRange(location: text.count, length: searchName.count)
        )
    }

    var includeMoreButton: Bool { searchName != nil }
}

struct NotificationCenterSegment {
    let title: String
    var sections: [NotificationCenterSection]
}

extension NotificationCenterDemoViewController {
    var savedSearchSegment: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Lagrede søk",
            sections: [
                NotificationCenterSection(
                    title: "I dag",
                    count: 2,
                    searchName: "Eiendom i Oslo",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: false,
                            content: SavedSearchAdData(
                                imagePath: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
                                locationText: "Iladalen",
                                title: "Meget lekker 2-roms med solrik balkong, optimal planløsning og heis. Flytt rett inn. Ingen forkjøp. Ingen dok. avgift.",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                                locationText: "Kragskogen/Holmenkollen",
                                title: "Lekker og innholdsrik endeleilighet med solrik sydvendt terrasse, garasje og god standard fra 2013/2014.",
                                priceText: "3 450 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: "I går",
                    count: 2,
                    searchName: "Drømmebilen",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/2d/ee/a2/2deea203ebc1da505db5676821ca88fb.jpg",
                                locationText: "Lyngdal",
                                title: "Opel Kadett KADETT 1.2 1200",
                                priceText: "45 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/1a/f9/23/1af923256d67b122f1c21fd41e19aa66.jpg",
                                locationText: "Kristiansand S",
                                title: "Opel Kadett KADETT C 1.2-0",
                                priceText: "23 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .feedbackCell(self, .initial, FeedbackViewModel(
                            title: "Heisann! Hvordan var det å bruke den nye lista med varslinger?",
                            positiveButtonTitle: "Gi rask tilbakemelding"
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: "Mandag 2. mars",
                    count: 10,
                    searchName: "Drømmeboliger",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                    ]
                )
            ]
        )
    }

    var savedSearchSegmentGroupedPerSearch: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Lagrede søk",
            sections: [
                NotificationCenterSection(
                    title: nil,
                    count: 2,
                    searchName: "Eiendom i Oslo",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: false,
                            content: SavedSearchAdData(
                                imagePath: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
                                locationText: "Iladalen",
                                title: "Meget lekker 2-roms med solrik balkong, optimal planløsning og heis. Flytt rett inn. Ingen forkjøp. Ingen dok. avgift.",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                                locationText: "Kragskogen/Holmenkollen",
                                title: "Lekker og innholdsrik endeleilighet med solrik sydvendt terrasse, garasje og god standard fra 2013/2014.",
                                priceText: "3 450 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: 2,
                    searchName: "Drømmebilen",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/2d/ee/a2/2deea203ebc1da505db5676821ca88fb.jpg",
                                locationText: "Lyngdal",
                                title: "Opel Kadett KADETT 1.2 1200",
                                priceText: "45 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/1a/f9/23/1af923256d67b122f1c21fd41e19aa66.jpg",
                                locationText: "Kristiansand S",
                                title: "Opel Kadett KADETT C 1.2-0",
                                priceText: "23 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .feedbackCell(self, .initial, FeedbackViewModel(
                            title: "Heisann! Hvordan var det å bruke den nye lista med varslinger?",
                            positiveButtonTitle: "Gi rask tilbakemelding"
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: 10,
                    searchName: "Drømmeboliger",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                    ]
                )
            ]
        )
    }

    var savedSearchSegmentFlat: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Lagrede søk",
            sections: [
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: "Eiendom i Oslo",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: false,
                            content: SavedSearchAdData(
                                imagePath: "https://jwproperty.com/files/wp-content/uploads/2015/01/Smart_House-Valley_Hua_Hin0131.jpg",
                                locationText: "Iladalen",
                                title: "Meget lekker 2-roms med solrik balkong, optimal planløsning og heis. Flytt rett inn. Ingen forkjøp. Ingen dok. avgift.",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: "Eiendom i Oslo",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                                locationText: "Kragskogen/Holmenkollen",
                                title: "Lekker og innholdsrik endeleilighet med solrik sydvendt terrasse, garasje og god standard fra 2013/2014.",
                                priceText: "3 450 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: "Drømmebilen",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/2d/ee/a2/2deea203ebc1da505db5676821ca88fb.jpg",
                                locationText: "Lyngdal",
                                title: "Opel Kadett KADETT 1.2 1200",
                                priceText: "45 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        )),
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: "Drømmebilen",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/1a/f9/23/1af923256d67b122f1c21fd41e19aa66.jpg",
                                locationText: "Kristiansand S",
                                title: "Opel Kadett KADETT C 1.2-0",
                                priceText: "23 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                    ]
                ),
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: "Drømmeboliger",
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                locationText: "Oslo",
                                title: "Oslo",
                                priceText: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                    ]
                )
            ]
        )
    }

    var personalSegment: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Tips til deg",
            sections: [
                NotificationCenterSection(
                    title: "I dag",
                    count: nil,
                    searchName: nil,
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: false,
                            content: PersonalAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                description: "Din favoritt er satt ned!",
                                title: "Flott enebolig i rolig strøk",
                                priceText: "3000 kr",
                                icon: .favorite
                            )
                        ))
                    ]
                ),
                NotificationCenterSection(
                    title: "I går",
                    count: nil,
                    searchName: nil,
                    items: [
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: PersonalAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                description: "Din favoritt er satt ned!",
                                title: "Flott enebolig i rolig strøk",
                                priceText: "3000 kr",
                                icon: .favorite
                            )
                        ))
                    ]
                )
            ]
        )
    }

    var emptyPersonalNotificationsSegment: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Tips til deg",
            sections: [
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: nil,
                    items: [
                        .emptyCell(EmptyNotificationsCellModel(
                            kind: .personal,
                            title: "Velkommen til varslinger!",
                            body: "Her vil du få varslinger om dine annonser, favoritter og nytt fra FINN."
                        ))
                    ]
                )
            ]
        )
    }

    var emptySavedSearchNotificationsSegment: NotificationCenterSegment {
        NotificationCenterSegment(
            title: "Lagrede søk",
            sections: [
                NotificationCenterSection(
                    title: nil,
                    count: nil,
                    searchName: nil,
                    items: [
                        .emptyCell(EmptyNotificationsCellModel(
                            kind: .savedSearch,
                            title: "La oss si ifra om nye annonser!",
                            body: "Søk etter noe du har lyst på og trykk \"Lagre søk\". Du får varslinger om nye annonser her."
                        ))
                    ]
                )
            ]
        )
    }
}
