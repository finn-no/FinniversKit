//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import MapKit

public protocol SearchResultMapViewDelegate: AnyObject {
    func searchResultMapView(_ view: SearchResultMapView, didSelect mapSettingsAction: MapSettingsButton.Actions, in button: MapSettingsButton)
    func searchResultMapView(_ view: SearchResultMapView, didSelect annotationView: MKAnnotationView)
    func searchResultMapView(_ view: SearchResultMapView, didUpdate userLocation: MKUserLocation)
    func searchResultMapViewRegionWillChangeDueToUserInteraction(_ view: SearchResultMapView)
    func searchResultMapViewRegionDidChange(_ view: SearchResultMapView)
}

public final class SearchResultMapView: UIView {

    private enum AnnotationIdentifier: String {
        case cluster = "clusterPOI"
        case poi = "POI"
    }

    public weak var delegate: SearchResultMapViewDelegate?

    public var zoomLevel: Double {
        return mapView.zoomLevel
    }

    public var centerCoordinate: CLLocationCoordinate2D {
        return mapView.centerCoordinate
    }

    public var visibleMapRect: MKMapRect {
        return mapView.visibleMapRect
    }

    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        return view
    }()

    private lazy var mapSettingsButton: MapSettingsButton = {
        let mapSettingsButton = MapSettingsButton(withAutoLayout: true)
        mapSettingsButton.delegate = self
        return mapSettingsButton
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func configure(withInitialRegion region: MKCoordinateRegion, andShowingUserLocation showingUserLocation: Bool) {
        setRegion(region, animated: false)
        showUserLocation(value: showingUserLocation)
    }

    public func showUserLocation(value: Bool) {
        mapView.showsUserLocation = value
    }

    public func setRegion(_ region: MKCoordinateRegion, animated: Bool) {
        mapView.setRegion(region, animated: animated)
    }

    public func setCenter(_ coordinate: CLLocationCoordinate2D, regionDistance: CLLocationDegrees, animated: Bool) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: animated)
    }

    public func setCenterOnUserLocation(regionDistance: CLLocationDegrees, animated: Bool) {
        if mapView.userLocation.location != nil {
            setCenter(mapView.userLocation.coordinate, regionDistance: regionDistance, animated: animated)
        }
    }

    public func setMapOverlay(_ newOverlay: MKTileOverlay) {
        if let lastOverlay = mapView.overlays.last {
            mapView.removeOverlay(lastOverlay)
        }

        mapView.addOverlay(newOverlay)
    }

    public func clearMapOverlay(_ overlay: MKTileOverlay) {
        mapView.removeOverlay(overlay)
    }

    public func addAnnotation(_ annotation: SearchResultMapViewAnnotation) {
        mapView.addAnnotation(annotation)
    }

    public func clearAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
    }

    public func focusAnnotations() {
        let annotationsToShow = mapView.annotations.filter { $0 is SearchResultMapViewAnnotation }
        mapView.showAnnotations(annotationsToShow, animated: true)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .milk

        addSubview(mapView)
        addSubview(mapSettingsButton)

        mapView.fillInSuperview()

        NSLayoutConstraint.activate([
            mapSettingsButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 8),
            mapSettingsButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8)
            ])
    }

}

// MARK: - Extensions

extension SearchResultMapView: MapSettingsButtonDelegate {

    public func mapSettingsButton(_ button: MapSettingsButton, didSelect action: MapSettingsButton.Actions) {
        delegate?.searchResultMapView(self, didSelect: action, in: button)
    }

}

extension SearchResultMapView: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }

        return MKOverlayRenderer(overlay: overlay)
    }

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }

        if let annotation = annotation as? SearchResultMapViewAnnotation {
            let marker = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.isCluster ? AnnotationIdentifier.cluster.rawValue : AnnotationIdentifier.poi.rawValue)
            marker.image = annotation.image
            marker.centerOffset = CGPoint(x: 0.5, y: 1.0)
            return marker
        }

        return nil
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        delegate?.searchResultMapView(self, didSelect: view)
    }

    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if let view = mapView.subviews.first {
            let isDueToUserInteraction = view.gestureRecognizers?.first(where: { $0.state == .began || $0.state == .ended })

            if isDueToUserInteraction != nil {
                delegate?.searchResultMapViewRegionWillChangeDueToUserInteraction(self)
            }
        }
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delegate?.searchResultMapViewRegionDidChange(self)
    }

    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        delegate?.searchResultMapView(self, didUpdate: userLocation)
    }

}
