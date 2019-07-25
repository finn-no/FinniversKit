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

    private static let baseUrl = "https://tile.openstreetmap.org/"

    private static func templateUrl(forMapType mapType: FinnMapType) -> String {
        return "\(FinnMapTile.baseUrl)/{z}/{x}/{y}.png"
    }

    convenience init(withMapType mapType: FinnMapType = .map) {
        self.init(urlTemplate: FinnMapTile.templateUrl(forMapType: mapType))
        canReplaceMapContent = true
    }

}
