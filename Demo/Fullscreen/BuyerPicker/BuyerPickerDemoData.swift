//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public class BuyerPickerDemoUser: BuyerPickerProfileModel {
    public let name: String
    public let image: URL?

    init(name: String, image: URL? = nil) {
        self.name = name
        self.image = image
    }
}

public struct BuyerPickerDemoData: BuyerPickerViewModel {
    public let title = "Velg den du gjorde handelen med:"
    public let profiles: [BuyerPickerProfileModel] = [
        BuyerPickerDemoUser(name: "Ola Nordmann", image: URL(string: "http://via.placeholder.com/44x44/111111/111111")),
        BuyerPickerDemoUser(name: "Per Johansen", image: URL(string: "http://via.placeholder.com/44x44/ff00ff/ff00ff")),
        BuyerPickerDemoUser(name: "Per"),
        BuyerPickerDemoUser(name: "FINN Bruker"),
        BuyerPickerDemoUser(name: "Test testesen", image: URL(string: "http://via.placeholder.com/44x44/ffff00/ffff00"))
    ]
    public let selectTitle = "Velg"
    public let confirmationTitle = "Du kan ikke endre valget ditt senere"

    public init() {}
}
