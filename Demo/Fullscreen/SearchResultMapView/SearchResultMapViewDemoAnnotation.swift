//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public class SearchResultMapViewDemoAnnotation: NSObject, MKAnnotation {

    let isCluster: Bool
    let id = Int.random(in: 0 ..< 100)

    public var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D, isCluster: Bool) {
        self.coordinate = coordinate
        self.isCluster = isCluster
    }

}
