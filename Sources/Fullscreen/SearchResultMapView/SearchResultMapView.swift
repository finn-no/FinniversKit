//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public final class SearchResultMapView: UIView {

    private var didSetupView = false

    private var regionOfNorway = MKCoordinateRegion.init(
        center: CLLocationCoordinate2D.init(latitude: 66.149068058495473, longitude: 17.653576306638673),
        span: MKCoordinateSpan.init(latitudeDelta: 19.853012316209828, longitudeDelta: 28.124998591005721)
    )

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        // TOOD: Set theese with open func configure
        view.addOverlay(FinnMapTile(withMapType: .map), level: .aboveLabels)
        view.setRegion(regionOfNorway, animated: false)
        return view
    }()

    private lazy var mapSettingsButton: MapSettingsButton = {
        let mapSettingsButton = MapSettingsButton(withAutoLayout: true)
        mapSettingsButton.delegate = self
        return mapSettingsButton
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
        mapView.addSubview(mapSettingsButton)

        NSLayoutConstraint.activate([
            mapSettingsButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 8),
            mapSettingsButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8)
            ])
    }

}

// MARK: - Extensions

extension SearchResultMapView: MapSettingsButtonDelegate {
    public func mapSettingsButtonDidSelectChangeMapTypeButton(_ view: MapSettingsButton) {

    }

    public func mapSettingsButtonDidSelectCenterMapButton(_ view: MapSettingsButton) {

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
