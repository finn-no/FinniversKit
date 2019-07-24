//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public final class SearchResultMapView: UIView {

    private var didSetupView = false
    
    private var regionOfNorway = MKCoordinateRegion.init(
        center: CLLocationCoordinate2D.init(latitude: 66.149068058495473, longitude: 17.653576306638673),
        span:MKCoordinateSpan.init(latitudeDelta: 19.853012316209828, longitudeDelta: 28.124998591005721)
    )
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.addOverlay(FinnMapTile(withMapType: .map), level: .aboveLabels)
        view.setRegion(regionOfNorway, animated: false)
        return view
    }()
    
    // MARK: - Public
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if didSetupView == false {
            setup()
            didSetupView = true
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        backgroundColor = .milk

        addSubview(mapView)
        mapView.fillInSuperview()
    }
    
}

extension SearchResultMapView: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
}
