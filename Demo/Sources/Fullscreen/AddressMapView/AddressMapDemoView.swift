//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import MapKit
import DemoKit

class AddressMapDemoView: UIView {
    private lazy var addressMapView: AddressMapView = {
        let view = AddressMapView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(addressMapView)
        addressMapView.fillInSuperview()
        configure(forTweakAt: 0)

        // Place a nice looking view instead of the mapView to prevent the UI tests from failing.
        for subview in addressMapView.subviews {
            guard let mapView = subview as? MKMapView else { break }
            let colorfulView = UIView(withAutoLayout: true)
            colorfulView.backgroundColor = .green100
            mapView.superview?.addSubview(colorfulView)
            let constraints: [NSLayoutConstraint] = [
                colorfulView.topAnchor.constraint(equalTo: mapView.topAnchor),
                colorfulView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
                colorfulView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
                colorfulView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
            mapView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak colorfulView] in
                mapView.isHidden = false
                colorfulView?.removeFromSuperview()
            })
        }
    }
}

extension AddressMapDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case addressData
        case postalcodeData
        case postalcodeShape0010
        case postalcodeShapeMultiPolygons
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .addressData:
            let location = CLLocationCoordinate2D(latitude: 65.10915470111108, longitude: 11.984673996759456)
            addressMapView.configureAnnotation(title: "Møllerøya 32, 7982 Bindalseidet", location: location)
            addressMapView.centerMap(location: location, regionDistance: 500, animated: false)
        case .postalcodeData:
            let location = CLLocationCoordinate2D(latitude: 59.925504072875661, longitude: 10.452107618894244)
            addressMapView.configureRadiusArea(500, location: location)
            addressMapView.centerMap(location: location, regionDistance: 1200, animated: false)
        case .postalcodeShape0010:
            let areas = [PolygonDemoArea.area0010]
            addressMapView.configurePolygons(areas.compactMap({ $0?.coordinates }))
            addressMapView.makePolygonOverlayVisible(additionalEdgeInsets: UIEdgeInsets.zero)
        case .postalcodeShapeMultiPolygons:
            let areas = [
                PolygonDemoArea.area0010,
                PolygonDemoArea(coordinates: [[10.74, 59.92], [10.75, 59.92], [10.74, 59.91]])
            ]
            addressMapView.configurePolygons(areas.compactMap({ $0?.coordinates }))
            addressMapView.makePolygonOverlayVisible(additionalEdgeInsets: UIEdgeInsets.zero)
        }
    }
}

// MARK: - AddressMapViewDelegate

extension AddressMapDemoView: AddressMapViewDelegate {
    func addressMapViewDidSelectPinButton(_ view: AddressMapView) {
        print("addressViewDidSelectCenterMapButton")
        view.makePolygonOverlayVisible(additionalEdgeInsets: UIEdgeInsets.zero)
    }

    func addressMapViewDidSelectViewModeButton(_ view: AddressMapView, sender: UIView) {
        print("addressViewDidSelectMapTypeButton")
    }

    func addressMapViewDidInteractWithMapView(_ addressMapView: AddressMapView) {
        print("addressMapViewDidInteractWithMapView")
    }
}

// MARK: - Demo data

private struct PolygonDemoData {
    let title: String
    let areas: [PolygonDemoArea?]
}

private struct PolygonDemoArea {
    private enum AddressViewDemoError: Error {
        case decodingError
    }

    let coordinates: [CLLocationCoordinate2D]

    init?(coordinates: [[CLLocationDegrees]]) {
        guard let convertedCoordinates = try? coordinates.map({ (degreesArray) -> CLLocationCoordinate2D in
            guard degreesArray.count == 2, let lat = degreesArray.last, let lon = degreesArray.first else {
                throw AddressViewDemoError.decodingError
            }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }) else {
            return nil
        }
        self.coordinates = convertedCoordinates
    }

    static let area0010 = PolygonDemoArea(coordinates: [
        [10.7244, 59.9181], [10.7252, 59.9185], [10.7264, 59.9192], [10.727099999999998, 59.919799999999995], [10.7274, 59.92], [10.727899999999998, 59.9202], [10.728499999999999, 59.9199], [10.7294, 59.919599999999996], [10.730299999999998, 59.9192], [10.729899999999999, 59.9184], [10.731199999999998, 59.917399999999994], [10.732099999999999, 59.9173], [10.7326, 59.917199999999994], [10.734699999999998, 59.9165], [10.734299999999998, 59.9161], [10.733899999999998, 59.9159], [10.7334, 59.9156], [10.7327, 59.9154], [10.730899999999998, 59.9153], [10.730199999999998, 59.9153], [10.7294, 59.9154], [10.728399999999999, 59.9154], [10.7266, 59.9154], [10.7252, 59.9155], [10.723999999999998, 59.9154], [10.723299999999998, 59.9154], [10.7228, 59.9154], [10.7227, 59.9157], [10.7228, 59.9161], [10.7229, 59.9163], [10.722999999999999, 59.916799999999995], [10.722999999999999, 59.916999999999994], [10.7234, 59.9173], [10.7244, 59.9181]
        ])
}
