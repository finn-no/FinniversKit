//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

public protocol AddressMapViewDelegate: AnyObject {
    func addressMapViewDidSelectPinButton(_ addressMapView: AddressMapView)
    func addressMapViewDidSelectViewModeButton(_ addressMapView: AddressMapView, sender: UIView)
    func addressMapViewDidInteractWithMapView(_ addressMapView: AddressMapView)
}

public class AddressMapView: UIView {
    public weak var delegate: AddressMapViewDelegate?

    // MARK: - Private properties

    private var tileOverlay: MKTileOverlay?
    private var circle: MKCircle?
    private var annotation: MKAnnotation?
    private var polygons = [MKPolygon]()

    private lazy var mapView: MKMapView = {
        let view = MKMapView(withAutoLayout: true)
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMapTap)))
        return view
    }()

    private lazy var viewModeButton: UIButton = {
        let button = UIButton.mapButton
        button.setImage(UIImage(named: .viewMode).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleViewModeButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var pinButton: UIButton = {
        let button = UIButton.mapButton
        button.setImage(UIImage(named: .pin).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handlePinButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Public API

    public func centerMap(location: CLLocationCoordinate2D, regionDistance: Double, animated: Bool) {
        let meters: CLLocationDistance = regionDistance
        let region = MKCoordinateRegion(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
        mapView.setRegion(region, animated: animated)
    }

    public func configureTileOverlay(_ tileOverlay: MKTileOverlay) {
        if let oldOverlay = self.tileOverlay {
            mapView.removeOverlay(oldOverlay)
        }
        mapView.addOverlay(tileOverlay, level: .aboveLabels)
        self.tileOverlay = tileOverlay
    }

    public func configureRadiusArea(_ radius: Double, location: CLLocationCoordinate2D) {
        removeCurrentAnnotationAndShapeOverlays()
        let newCircle = MKCircle(center: location, radius: radius)
        mapView.addOverlay(newCircle, level: .aboveLabels)
        circle = newCircle
    }

    public func configureAnnotation(title: String, location: CLLocationCoordinate2D) {
        removeCurrentAnnotationAndShapeOverlays()
        let newAnnotation = AddressAnnotation(title: title, location: location)
        mapView.addAnnotation(newAnnotation)
        annotation = newAnnotation
    }

    public func makePolygonOverlayVisible(additionalEdgeInsets: UIEdgeInsets = .zero) {
        guard let firstPolygon = polygons.first else {
            return
        }

        let mapRect = polygons.dropFirst().reduce(firstPolygon.boundingMapRect, { (mapRect, polygon) -> MKMapRect in
            return polygon.boundingMapRect.union(mapRect)
        })
        let edgePadding = UIEdgeInsets(
            top: 16 + additionalEdgeInsets.top,
            left: 16 + additionalEdgeInsets.left,
            bottom: 16 + additionalEdgeInsets.bottom,
            right: 16 + additionalEdgeInsets.right
        )

        mapView.setVisibleMapRect(mapRect, edgePadding: edgePadding, animated: false)
    }

    public func configurePolygons(_ polygonPoints: [[CLLocationCoordinate2D]]) {
        removeCurrentAnnotationAndShapeOverlays()
        polygonPoints.forEach { points in
            let newPolygon = MKPolygon(coordinates: points, count: points.count)
            mapView.addOverlay(newPolygon)
            polygons.append(newPolygon)
        }
    }

    public func changeMapType(_ mapType: MKMapType) {
        mapView.mapType = mapType
    }

    public func configureMapZoomRange(_ range: MapZoomRange) {
        mapView.setCameraZoomRange(range.toCameraZoomRange(), animated: false)
    }

    // MARK: - Setup

    private func setup() {
        addSubview(mapView)
        addSubview(viewModeButton)
        addSubview(pinButton)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),

            viewModeButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            viewModeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            viewModeButton.widthAnchor.constraint(equalToConstant: 46),
            viewModeButton.heightAnchor.constraint(equalTo: viewModeButton.widthAnchor),

            pinButton.topAnchor.constraint(equalTo: viewModeButton.bottomAnchor, constant: .spacingS),
            pinButton.trailingAnchor.constraint(equalTo: viewModeButton.trailingAnchor),
            pinButton.widthAnchor.constraint(equalTo: viewModeButton.heightAnchor),
            pinButton.heightAnchor.constraint(equalTo: viewModeButton.widthAnchor)
        ])
    }

    @objc private func handleViewModeButtonTap() {
        delegate?.addressMapViewDidSelectViewModeButton(self, sender: viewModeButton)
    }

    @objc private func handlePinButtonTap() {
        delegate?.addressMapViewDidSelectPinButton(self)
    }

    @objc private func handleMapTap() {
        delegate?.addressMapViewDidInteractWithMapView(self)
    }

    private func removeCurrentAnnotationAndShapeOverlays() {
        if let oldAnnotation = annotation {
            mapView.removeAnnotation(oldAnnotation)
        }

        if let oldCircle = circle {
            mapView.removeOverlay(oldCircle)
        }

        polygons.forEach({ mapView.removeOverlay($0) })
        polygons.removeAll()
    }
}

// MARK: - MKMapViewDelegate

extension AddressMapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.btnPrimary
            circle.fillColor = UIColor.btnPrimary.withAlphaComponent(0.15)
            circle.lineWidth = 2
            return circle
        } else if overlay is MKPolygon {
            let polygon = MKPolygonRenderer(overlay: overlay)
            polygon.strokeColor = UIColor.btnPrimary
            polygon.fillColor = UIColor.btnPrimary.withAlphaComponent(0.15)
            polygon.lineWidth = 2
            return polygon
        } else if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }

    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        delegate?.addressMapViewDidInteractWithMapView(self)
    }
}

// MARK: - Private types

private class AddressAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(title: String, location: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = location
    }
}

private extension UIButton {
    static var mapButton: UIButton {
        let button = FloatingButton(withAutoLayout: true, style: .mapButton)
        return button
    }
}

private extension FloatingButton.Style {
    static var mapButton: FloatingButton.Style {
        .default.overrideStyle(
            shadowColor: .black.withAlphaComponent(0.5),
            shadowOffset: CGSize(width: 0, height: 3),
            shadowRadius: 3
        )
    }
}
