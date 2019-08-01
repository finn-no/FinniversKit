//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

extension MKMapView {

    func setZoomLevel(to level: Double, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, level) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }

    func getCurrentZoomLevel() -> Double {
        return log2(360 * (Double(frame.size.width / 256) / region.span.longitudeDelta)) + 1
    }

}
