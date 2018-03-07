//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SwitchDefaultData1: SwitchViewModel {
    public let headerText = "Anbefalinger"
    public let onDescriptionText = "Vi gir deg relevante tips på forsiden"
    public let offDescriptionText = "Relevante tips er slått av"

    public init() {}
}

public struct SwitchDefaultData2: SwitchViewModel {
    public let headerText = "Smart reklame"
    public let onDescriptionText = "Vi leter for deg når du gjør andre ting"
    public let offDescriptionText = "Du får ikke relevant FINN-innhold når du ikke leter"

    public init() {}
}
