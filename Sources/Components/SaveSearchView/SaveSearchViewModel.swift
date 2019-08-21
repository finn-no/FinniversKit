//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol SaveSearchViewModel {
    var searchPlaceholderText: String { get }

    var pushTitle: String { get }
    var pushDetail: String { get }
    var pushIsOn: Bool { get }

    var emailTitle: String { get }
    var emailDetail: String { get }
    var emailIsOn: Bool { get }
}

extension SaveSearchViewModel {
    var pushSwitchViewModel: SwitchViewModel {
        return SwitchViewDefaultModel(
            title: pushTitle,
            detail: pushDetail,
            initialSwitchValue: pushIsOn
        )
    }

    var emailSwitchViewModel: SwitchViewModel {
        return SwitchViewDefaultModel(
            title: emailTitle,
            detail: emailDetail,
            initialSwitchValue: emailIsOn
        )
    }
}
