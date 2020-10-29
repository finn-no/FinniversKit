//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import FinniversKit

public class BuyerPickerDemoUser: BuyerPickerProfileModel {
    public let name: String
    public let image: URL?
    public let chevronText: String?

    init(name: String, image: URL? = nil, chevronText: String? = nil) {
        self.name = name
        self.image = image
        self.chevronText = chevronText
    }
}

public struct BuyerPickerDemoData: BuyerPickerViewModel {
    public let title = "Velg den du gjorde handelen med:"
    public let profiles: [BuyerPickerProfileModel] = [
        BuyerPickerDemoUser(name: "Ola Nordmann", image: URL(string: "http://via.placeholder.com/44x44/111111/111111")),
        BuyerPickerDemoUser(name: "Per Johansen", image: URL(string: "http://via.placeholder.com/44x44/ff00ff/ff00ff")),
        BuyerPickerDemoUser(name: "Test testesen", image: URL(string: "http://via.placeholder.com/44x44/ffff00/ffff00")),
    ]
    public let fallbackCell: BuyerPickerProfileModel = BuyerPickerDemoUser(name: "Ingen av disse?")
    public let selectTitle = "Velg"
    public let confirmationTitle = "Du kan ikke endre valget ditt senere"

    public init() {}
}
