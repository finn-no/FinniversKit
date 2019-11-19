//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

public protocol AddressViewDelegate: AnyObject {
    func addressViewDidSelectCopyButton(_ addressView: AddressView)
    func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView, sender: UIView)
    func addressViewDidSelectCenterMapButton(_ addressView: AddressView)
    func addressViewDidSelectMapTypeButton(_ addressView: AddressView)
}

public class AddressView: UIView {
    private lazy var mapView: MKMapView = {
        let view = MKMapView(withAutoLayout: true)
        view.isRotateEnabled = false
        view.isPitchEnabled = false
        view.delegate = self
        return view
    }()

    private lazy var addressCardView: AddressCardView = {
        let view = AddressCardView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var mapTypeButton: UIButton = {
        let button = UIButton.mapButton
        button.setImage(UIImage(named: .viewMode).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleMapTypeButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var centerMapButton: UIButton = {
        let button = UIButton.mapButton
        button.setImage(UIImage(named: .pin).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleCenterMapButtonTap), for: .touchUpInside)
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public weak var delegate: AddressViewDelegate?

    public var model: AddressViewModel? {
        didSet {
            guard let model = model else { return }
            addressCardView.model = model
        }
    }

    public func centerMap(location: CLLocationCoordinate2D, regionDistance: Double, animated: Bool) {
        let meters: CLLocationDistance = regionDistance
        let region = MKCoordinateRegion(center: location, latitudinalMeters: meters, longitudinalMeters: meters)
        mapView.setRegion(region, animated: animated)
    }

    private var tileOverlay: MKTileOverlay?

    public func configureTileOverlay(_ tileOverlay: MKTileOverlay) {
        if let oldOverlay = self.tileOverlay {
            mapView.removeOverlay(oldOverlay)
        }
        mapView.addOverlay(tileOverlay, level: .aboveLabels)
        self.tileOverlay = tileOverlay
    }

    private var circle: MKCircle?

    public func configureRadiusArea(_ radius: Double, location: CLLocationCoordinate2D) {
        removeCurrentAnnotationAndShapeOverlays()
        let newCircle = MKCircle(center: location, radius: radius)
        mapView.addOverlay(newCircle)
        circle = newCircle
    }

    private var annotation: MKAnnotation?

    public func configureAnnotation(title: String, location: CLLocationCoordinate2D) {
        removeCurrentAnnotationAndShapeOverlays()
        let newAnnotation = AddressAnnotation(title: title, location: location)
        mapView.addAnnotation(newAnnotation)
        annotation = newAnnotation
    }

    private var polygons = [MKPolygon]()

    public func makePolygonOverlayVisible() {
        guard let firstPolygon = polygons.first else {
            return
        }
        let mapRect = polygons.dropFirst().reduce(firstPolygon.boundingMapRect, { (mapRect, polygon) -> MKMapRect in
            return polygon.boundingMapRect.union(mapRect)
        })

        let bottomInset = UIDevice.isIPad() ? 16 : 16 + .mediumLargeSpacing
        mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: 16, left: 16, bottom: bottomInset, right: 16), animated: false)
    }

    public func configurePolygons(_ polygonPoints: [[CLLocationCoordinate2D]]) {
        removeCurrentAnnotationAndShapeOverlays()
        polygonPoints.forEach { points in
            let newPolygon = MKPolygon(coordinates: points, count: points.count)
            mapView.addOverlay(newPolygon)
            polygons.append(newPolygon)
        }

        makePolygonOverlayVisible()
    }

    public func changeMapType(_ mapType: MKMapType) {
        mapView.mapType = mapType
    }
}

// MARK: - Private methods

private extension AddressView {
    func setup() {
        addSubview(mapView)
        addSubview(addressCardView)
        addSubview(mapTypeButton)
        addSubview(centerMapButton)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),

            mapTypeButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            mapTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            mapTypeButton.widthAnchor.constraint(equalToConstant: 46),
            mapTypeButton.heightAnchor.constraint(equalTo: mapTypeButton.widthAnchor),

            centerMapButton.topAnchor.constraint(equalTo: mapTypeButton.bottomAnchor, constant: .mediumSpacing),
            centerMapButton.trailingAnchor.constraint(equalTo: mapTypeButton.trailingAnchor),
            centerMapButton.widthAnchor.constraint(equalTo: mapTypeButton.heightAnchor),
            centerMapButton.heightAnchor.constraint(equalTo: mapTypeButton.widthAnchor)
        ])

        if UIDevice.isIPad() {
            NSLayoutConstraint.activate([
                mapView.bottomAnchor.constraint(equalTo: bottomAnchor),

                addressCardView.widthAnchor.constraint(equalToConstant: 350),
                addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
                addressCardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
                ])
        } else {
            NSLayoutConstraint.activate([
                mapView.bottomAnchor.constraint(equalTo: addressCardView.topAnchor, constant: .mediumLargeSpacing),

                addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
                addressCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
                addressCardView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
    }

    @objc func handleCenterMapButtonTap() {
        delegate?.addressViewDidSelectCenterMapButton(self)
    }

    @objc func handleMapTypeButtonTap() {
        delegate?.addressViewDidSelectMapTypeButton(self)
    }

    func removeCurrentAnnotationAndShapeOverlays() {
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

extension AddressView: AddressCardViewDelegate {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView) {
        delegate?.addressViewDidSelectCopyButton(self)
    }

    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView, sender: UIView) {
        delegate?.addressViewDidSelectGetDirectionsButton(self, sender: sender)
    }
}

extension AddressView: MKMapViewDelegate {
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
}

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
        let button = FloatingButton(withAutoLayout: true)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5
        return button
    }
}
