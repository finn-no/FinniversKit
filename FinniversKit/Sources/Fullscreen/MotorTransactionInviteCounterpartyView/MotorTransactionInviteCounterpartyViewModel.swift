//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

// swiftlint:disable:next type_name
public struct MotorTransactionInviteCounterpartyViewModel: BuyerPickerViewModel {
    public let title: String
    public let profiles: [BuyerPickerProfileModel]
    public let selectTitle: String
    public let confirmationTitle: String
    public let selectLaterButtonText: String

    public init(
        title: String,
        profiles: [BuyerPickerProfileModel],
        selectTitle: String,
        confirmationTitle: String,
        selectLaterButtonText: String
    ) {
        self.title = title
        self.profiles = profiles
        self.selectTitle = selectTitle
        self.confirmationTitle = confirmationTitle
        self.selectLaterButtonText = selectLaterButtonText
    }
}

// swiftlint:disable:next type_name
public struct MotorTransactionInviteCounterpartyProfileViewModel: BuyerPickerProfileModel, Hashable {
    public let name: String
    public let image: URL?
    public let chevronText: String?

    public init(
        name: String,
        image: URL?,
        chevronText: String? = nil
    ) {
        self.name = name
        self.image = image
        self.chevronText = chevronText
    }
}
