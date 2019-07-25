//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

enum FinnMapType: String, CaseIterable {
    case map = "normap"
    case satelite = "norortho"
    case hybrid = "norhybrid"
}

public class FinnMapTile: MKTileOverlay {

    private static let baseUrl = "http://maptiles.finn.no"

    private static func templateUrl(forMapType mapType: FinnMapType) -> String {
        return "\(FinnMapTile.baseUrl)/tileService/1.0.3/\(mapType.rawValue)/{z}/{x}/{y}"
    }

    convenience init(withMapType mapType: FinnMapType = .map) {
        self.init(urlTemplate: FinnMapTile.templateUrl(forMapType: mapType))
        canReplaceMapContent = true
    }

}
