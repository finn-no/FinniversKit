//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//
import FinnUI
import FinniversKit

struct SavedSearchAdData: SavedSearchNotificationCellContent {
    let imagePath: String?
    let title: String
    var subtitle: String
    var price: String
    let ribbonViewModel: RibbonViewModel?
}

struct PersonalAdData: PersonalNotificationCellContent {
    let imagePath: String?
    let title: String
    let subtitle: String
    let price: String
    let icon: PersonalNotificationIconView.Kind
}

struct NotificationCenterItem: NotificationCellModel {
    var isRead: Bool
    var content: NotificationCellContent
}

struct NotificationCenterSection: NotificationCenterHeaderViewModel {
    let title: String?
    let count: Int?
    let searchName: String?
    var items: [NotificationCenterCellType]
    
    var savedSearchButtonModel: SavedSearchHeaderButtonModel? {
        guard let searchName = searchName, let count = count else { return nil }
        let text = "\(count) nye treff "
        return SavedSearchHeaderButtonModel(
            text: text + searchName,
            highlightedRange: NSRange(location: text.count, length: searchName.count)
        )
    }
    
    var overflow: Bool? {
        count ?? 0 > 5
    }
}

struct NotificationCenterSegment {
    let title: String
    var sections: [NotificationCenterSection]
}

extension NotificationCenterDemoView {
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
                                title: "Iladalen",
                                subtitle: "Meget lekker 2-roms med solrik balkong, optimal planløsning og heis. Flytt rett inn. Ingen forkjøp. Ingen dok. avgift.",
                                price: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
                                title: "Kragskogen/Holmenkollen",
                                subtitle: "Lekker og innholdsrik endeleilighet med solrik sydvendt terrasse, garasje og god standard fra 2013/2014.",
                                price: "3 450 000 kr",
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
                                title: "Lyngdal",
                                subtitle: "Opel Kadett KADETT 1.2 1200",
                                price: "45 000 kr",
                                ribbonViewModel: .init(style: .warning, title: "Solgt")
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/originals/1a/f9/23/1af923256d67b122f1c21fd41e19aa66.jpg",
                                title: "Kristiansand S",
                                subtitle: "Opel Kadett KADETT C 1.2-0",
                                price: "23 000 kr",
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
                                title: "Oslo",
                                subtitle: "Oslo",
                                price: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                title: "Oslo",
                                subtitle: "Oslo",
                                price: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                title: "Oslo",
                                subtitle: "Oslo",
                                price: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                title: "Oslo",
                                subtitle: "Oslo",
                                price: "2 950 000 kr",
                                ribbonViewModel: nil
                            )
                        )),
                        .notificationCell(NotificationCenterItem(
                            isRead: true,
                            content: SavedSearchAdData(
                                imagePath: "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
                                title: "Oslo",
                                subtitle: "Oslo",
                                price: "2 950 000 kr",
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
                                title: "Din favoritt er satt ned!",
                                subtitle: "Flott enebolig i rolig strøk",
                                price: "3000 kr",
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
                                title: "Din favoritt er satt ned!",
                                subtitle: "Flott enebolig i rolig strøk",
                                price: "3000 kr",
                                icon: .favorite
                            )
                        ))
                    ]
                )
            ]
        )
    }
    
//    static var emptyPersonalSegment: NotificationCenterSegment {
//        NotificationCenterSegment(
//            title: "Tips til deg",
//            sections: [
//                NotificationCenterSection(
//                    title: nil,
//                    count: nil,
//                    searchName: nil,
//                    items: [
//                        NotificationCenterItem(
//                            isRead: true,
//                            content: EmptyPersonalNotificationCellContent(
//                                title: "Velkommen til varslinger, Solfrid!",
//                                message: "Her vil du få varslinger om dine annonser, favoritter og nytt fra FINN."
//                            )
//                        )
//                    ]
//                )
//            ]
//        )
//    }
//
//    static var emptySavedSearchSegment: NotificationCenterSegment {
//        NotificationCenterSegment(
//            title: "Lagrede søk",
//            sections: [
//                NotificationCenterSection(
//                    title: nil,
//                    count: nil,
//                    searchName: nil,
//                    items: [
//                        NotificationCenterItem(
//                            isRead: true,
//                            cellContent: EmptySavedSearchNotificationCellContent(
//                                title: "La oss si fra om nye annonser!",
//                                message: "Søk etter noe du har lyst på og trykk «Lagre søk». Du får varslinger om nye annonser her."
//                            )
//                        )
//                    ]
//                )
//            ]
//        )
//    }
}
