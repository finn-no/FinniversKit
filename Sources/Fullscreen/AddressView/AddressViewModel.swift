//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AddressViewModel {
    var mapTypes: [String] { get }
    var selectedMapType: Int { get }
    var title: String { get }
    var subtitle: String { get }
    var copyButtonTitle: String { get }
    var getDirectionsButtonTitle: String { get }

    @available(iOS 13.0, *)
    var mapZoomRange: MapZoomRange? { get }
}
