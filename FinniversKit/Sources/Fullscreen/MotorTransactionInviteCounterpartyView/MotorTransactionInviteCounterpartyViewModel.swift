//
//  Copyright © 2020 FINN AS. All rights reserved.
//

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
public struct MotorTransactionInviteCounterpartyProfileViewModel: BuyerPickerProfileModel {
    public var name: String
    public var image: URL?
    public var chevronText: String?
    public let id: UUID
        self.id = UUID()
}
