//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public class ReviewViewUser: ReviewViewProfileModel {
    public let showMessages = "Vis samtalen"
    public let name: String
    public let image: URL?

    init(name: String, image: URL? = nil) {
        self.name = name
        self.image = image
    }
}

public struct ReviewViewDefaultData: ReviewViewModel {
    public let title = "Velg den du gjorde handelen med:"
    public let profiles: [ReviewViewProfileModel] = [
        ReviewViewUser(name: "Ola Nordmann", image: URL(string: "http://via.placeholder.com/44x44/111111/111111")),
        ReviewViewUser(name: "Per Johansen", image: URL(string: "http://via.placeholder.com/44x44/ff00ff/ff00ff")),
        ReviewViewUser(name: "Per"),
        ReviewViewUser(name: "FINN Bruker"),
        ReviewViewUser(name: "Test testesen", image: URL(string: "http://via.placeholder.com/44x44/ffff00/ffff00"))
    ]
    public let selectTitle = "Velg"
    public let confirmationTitle = "Du kan ikke endre valget ditt senere"

    public init() {}
}
