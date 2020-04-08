//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol BuyerPickerViewModel {
    var title: String { get }
    var profiles: [BuyerPickerProfileModel] { get }
    var selectTitle: String { get }
    var confirmationTitle: String { get }
}

public protocol BuyerPickerProfileModel {
    var name: String { get }
    var image: URL? { get }
}
