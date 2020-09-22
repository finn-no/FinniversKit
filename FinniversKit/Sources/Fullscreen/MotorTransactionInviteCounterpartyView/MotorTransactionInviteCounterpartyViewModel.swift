//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

// swiftlint:disable:next type_name
public struct MotorTransactionInviteCounterpartyViewModel: BuyerPickerViewModel {
    public var title: String
    public var profiles: [BuyerPickerProfileModel]
    public var selectTitle: String
    public var confirmationTitle: String
    public var selectLaterButtonText: String

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
public struct MotorTransactionInviteCounterpartyProfileViewModel: BuyerPickerProfileModel {
    public var name: String
    public var image: URL?
    public var chevronText: String?
}
