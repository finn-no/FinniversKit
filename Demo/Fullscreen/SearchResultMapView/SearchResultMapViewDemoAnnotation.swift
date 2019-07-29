//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit
import FinniversKit

public class SearchResultMapViewDemoAnnotation: NSObject, SearchResultMapAnnotation {

    public var isCluster: Bool

    public var image: UIImage

    public var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D, image: UIImage, isCluster: Bool) {
        self.coordinate = coordinate
        self.isCluster = isCluster
        self.image = image
    }

}
