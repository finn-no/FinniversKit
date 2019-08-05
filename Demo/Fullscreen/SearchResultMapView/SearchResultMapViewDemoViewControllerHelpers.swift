//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit
import FinniversKit

public class SearchResultMapViewDemoAnnotation: NSObject, SearchResultMapViewAnnotation {

    public var isCluster: Bool
    public var image: UIImage
    public var coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D, image: UIImage, isCluster: Bool) {
        self.coordinate = coordinate
        self.isCluster = isCluster
        self.image = image
    }

}

public struct SearchResultMapViewAnnotationFactory {

    public static let centerLocation = CLLocationCoordinate2D(latitude: 59.9458, longitude: 10.7800)

    public static var tileOverlay: MKTileOverlay = {
        let tile = MKTileOverlay(urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png")
        tile.canReplaceMapContent = true
        return tile
    }()

    public static func create(numberOfAnnotations: Int) -> [SearchResultMapViewDemoAnnotation] {
        return (0 ..< numberOfAnnotations).map { _ in
            let isCluster = Double.random(in: 0...1) < 0.2
            let image = UIImage(named: isCluster ? .distance : .pin)
            let latitude = SearchResultMapViewAnnotationFactory.centerLocation.latitude + Double.random(in: 0...0.0065)
            let longitude = SearchResultMapViewAnnotationFactory.centerLocation.longitude + Double.random(in: 0...0.0045)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            return SearchResultMapViewDemoAnnotation(
                coordinate: coordinate,
                image: image,
                isCluster: isCluster
            )
        }
    }
}
