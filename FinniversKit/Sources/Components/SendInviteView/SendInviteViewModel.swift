//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public struct SendInviteViewModel {
    public let title: String
    public let profileName: String
    public let sendInviteButtonText: String
    public let sendInviteLaterButtonText: String

    public init(
        title: String,
        profileName: String,
        sendInviteButtonText: String,
        sendInviteLaterButtonText: String
    ) {
        self.title = title
        self.profileName = profileName
        self.sendInviteButtonText = sendInviteButtonText
        self.sendInviteLaterButtonText = sendInviteLaterButtonText
    }
}
