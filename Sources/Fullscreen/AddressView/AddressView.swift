//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

public protocol AddressViewDelegate: AnyObject {
    func addressViewDidSelectCopyButton(_ addressView: AddressView)
    func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView, sender: UIView)
    func addressViewDidSelectCenterMapButton(_ addressView: AddressView)
    func addressView(_ addressView: AddressView, didSelectMapTypeAtIndex index: Int)
}

public class AddressView: UIView {
    private lazy var mapTypeSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(withAutoLayout: true)
        control.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        control.tintColor = .primaryBlue
        return control
    }()

    private lazy var segmentContainer: UIView = {
        let segmentContainer = UIView(withAutoLayout: true)
        segmentContainer.backgroundColor = .white
        segmentContainer.addSubview(mapTypeSegmentControl)
        segmentContainer.layer.masksToBounds = false
        segmentContainer.layer.shadowOpacity = 0.3
        segmentContainer.layer.shadowRadius = 3
        segmentContainer.layer.shadowOffset = .zero
        segmentContainer.layer.shadowColor = UIColor.black.cgColor

        if UIDevice.isIPad() {
            NSLayoutConstraint.activate([
                mapTypeSegmentControl.widthAnchor.constraint(equalToConstant: 350),
                mapTypeSegmentControl.centerXAnchor.constraint(equalTo: segmentContainer.centerXAnchor)
                ])
        } else {
            NSLayoutConstraint.activate([
                mapTypeSegmentControl.leadingAnchor.constraint(equalTo: segmentContainer.leadingAnchor, constant: .mediumLargeSpacing),
                mapTypeSegmentControl.trailingAnchor.constraint(equalTo: segmentContainer.trailingAnchor, constant: -.mediumLargeSpacing)
                ])
        }

        NSLayoutConstraint.activate([
            mapTypeSegmentControl.topAnchor.constraint(equalTo: segmentContainer.topAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.bottomAnchor.constraint(equalTo: segmentContainer.bottomAnchor, constant: -.mediumLargeSpacing)
            ])

        return segmentContainer
    }()

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

    private lazy var centerMapButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.backgroundColor = .milk
        button.tintColor = .primaryBlue

        button.layer.cornerRadius = 23
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5

        button.setImage(UIImage(named: .pin), for: .normal)
        button.setImage(UIImage(named: .pin), for: .highlighted)
        button.addTarget(self, action: #selector(centerMapButtonAction), for: .touchUpInside)

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

            mapTypeSegmentControl.removeAllSegments()
            for (index, segment) in model.mapTypes.enumerated() {
                mapTypeSegmentControl.insertSegment(withTitle: segment, at: index, animated: false)
            }
            mapTypeSegmentControl.selectedSegmentIndex = model.selectedMapType
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
        addSubview(segmentContainer)
        insertSubview(mapView, belowSubview: segmentContainer)
        addSubview(addressCardView)
        addSubview(centerMapButton)

        NSLayoutConstraint.activate([
            segmentContainer.topAnchor.constraint(equalTo: topAnchor),
            segmentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            mapView.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),

            centerMapButton.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor, constant: .mediumLargeSpacing),
            centerMapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            centerMapButton.widthAnchor.constraint(equalToConstant: 46),
            centerMapButton.heightAnchor.constraint(equalTo: centerMapButton.widthAnchor)
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

    @objc func mapTypeChanged() {
        delegate?.addressView(self, didSelectMapTypeAtIndex: mapTypeSegmentControl.selectedSegmentIndex)
    }

    @objc func centerMapButtonAction() {
        delegate?.addressViewDidSelectCenterMapButton(self)
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
            circle.strokeColor = UIColor.primaryBlue
            circle.fillColor = UIColor.primaryBlue.withAlphaComponent(0.3)
            circle.lineWidth = 2
            return circle
        } else if overlay is MKPolygon {
            let polygon = MKPolygonRenderer(overlay: overlay)
            polygon.strokeColor = UIColor.primaryBlue
            polygon.fillColor = UIColor.primaryBlue.withAlphaComponent(0.3)
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
