//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

extension MKMapView {

    var zoomLevel: Double {
        return log2(360 * (Double(frame.size.width / 256) / region.span.longitudeDelta)) + 1
    }

    func setCenter(coordinate: CLLocationCoordinate2D, zoomLevel: Double, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, zoomLevel) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: animated)
    }

    func setZoomLevel(to zoomLevel: Double, animated: Bool) {
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, zoomLevel) * Double(frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }

}
