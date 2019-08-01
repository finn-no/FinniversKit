//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

extension MKMapView {

    var zoomLevel: Double {
        return log2(360 * (Double(frame.size.width / 256) / region.span.longitudeDelta)) + 1
    }

}
