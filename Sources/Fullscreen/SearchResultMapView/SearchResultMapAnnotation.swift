//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public protocol SearchResultMapAnnotation: MKAnnotation {
    var isCluster: Bool { get }
    var image: UIImage { get }
}
