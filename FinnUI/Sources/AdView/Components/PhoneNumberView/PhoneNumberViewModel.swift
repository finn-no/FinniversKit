//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import Foundation

public struct PhoneNumberViewModel {
    public let phoneNumber: String
    public let revealTitle: String
    public let sectionTitle: String

    public init(phoneNumber: String, revealTitle: String, sectionTitle: String) {
        self.phoneNumber = phoneNumber
        self.revealTitle = revealTitle
        self.sectionTitle = sectionTitle
    }
}

extension PhoneNumberViewModel {
    static let sampleData = PhoneNumberViewModel(
        phoneNumber: "+47 XXX XX XXX",
        revealTitle: "Vis telefonnummer",
        sectionTitle: "Mobil"
    )
}
