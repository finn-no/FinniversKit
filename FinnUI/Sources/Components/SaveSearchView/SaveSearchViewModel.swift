//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public struct SaveSearchViewModel {
    public let searchTitle: String?
    public let editNameButtonTitle: String
    public let deleteSearchButtonTitle: String?

    public let notificationCenterSwitchViewModel: SwitchViewModel
    public let pushSwitchViewModel: SwitchViewModel
    public let emailSwitchViewModel: SwitchViewModel

    public init(
        searchTitle: String?,
        editNameButtonTitle: String,
        deleteSearchButtonTitle: String?,
        notificationCenterSwitchViewModel: SwitchViewModel,
        pushSwitchViewModel: SwitchViewModel,
        emailSwitchViewModel: SwitchViewModel
    ) {
        self.searchTitle = searchTitle
        self.editNameButtonTitle = editNameButtonTitle
        self.deleteSearchButtonTitle = deleteSearchButtonTitle
        self.notificationCenterSwitchViewModel = notificationCenterSwitchViewModel
        self.pushSwitchViewModel = pushSwitchViewModel
        self.emailSwitchViewModel = emailSwitchViewModel
    }
}
