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
