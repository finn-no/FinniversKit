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
    public let title = "Gratulerer med handelen!\nGi en vurdering og fortell hvordan det gikk."
    public let subTitle = "Hvem vil du gi en vurdering til?"
    public let cells: [ReviewViewProfileModel] = [
        ReviewViewUser(name: "Ola Nordmann", image: URL(string: "http://via.placeholder.com/44x44/111111/111111")),
        ReviewViewUser(name: "Per Johansen", image: URL(string: "http://via.placeholder.com/44x44/ff00ff/ff00ff")),
        ReviewViewUser(name: "Per"),
        ReviewViewUser(name: "FINN Bruker"),
        ReviewViewUser(name: "Test testesen", image: URL(string: "http://via.placeholder.com/44x44/ffff00/ffff00")),
    ]

    public init() {
    }
}
