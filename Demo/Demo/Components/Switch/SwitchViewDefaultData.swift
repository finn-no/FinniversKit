//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SwitchDefaultData1: SwitchViewModel {
    public let title = "Anbefalinger"
    public let detail = "Vi gir deg relevante tips på forsiden"
    public let initialSwitchValue = true

    public init() {}
}

public struct SwitchDefaultData2: SwitchViewModel {
    public let title = "Smart reklame"
    public let detail = "Vi leter for deg når du gjør andre ting"
    public let initialSwitchValue = false

    public init() {}
}
