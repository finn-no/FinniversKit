//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

@available(iOS 13.0, *)
public struct MapZoomRange {
    public var minCenterCoordinateDistance: CLLocationDistance?
    public var maxCenterCoordinateDistance: CLLocationDistance?

    public init(minCenterCoordinateDistance minDistance: CLLocationDistance? = nil, maxCenterCoordinateDistance maxDistance: CLLocationDistance? = nil) {
        minCenterCoordinateDistance = minDistance
        maxCenterCoordinateDistance = maxDistance
    }

    func toCameraZoomRange() -> MKMapView.CameraZoomRange? {
        let zoomRange: MKMapView.CameraZoomRange?
        switch (minCenterCoordinateDistance, maxCenterCoordinateDistance) {
        case (.some(let min), .some(let max)):
            zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: min, maxCenterCoordinateDistance: max)
        case (.some(let min), _):
            zoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: min)
        case (_, .some(let max)):
            zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: max)
        case (.none, .none):
            zoomRange = nil
        }
        return zoomRange ?? MKMapView.CameraZoomRange()
    }
}
