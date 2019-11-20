//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import MapKit

private enum MapTypes: Int, CaseIterable {
    case standard
    case satellite
    case hybrid

    var value: String {
        switch self {
        case .standard: return "Kart"
        case .satellite: return "Flyfoto"
        case .hybrid: return "Hybrid"
        }
    }
}

private struct AddressViewData: AddressViewModel {
    @available(iOS 13.0, *)
    var mapZoomRange: MapZoomRange? {
        return nil
    }

    var mapTypes: [String] {
        return MapTypes.allCases.map { $0.value }
    }
    var title: String
    var subtitle: String
    var copyButtonTitle: String
    var selectedMapType = 0
    var getDirectionsButtonTitle = "Åpne veibeskrivelse"

    init(title: String, subtitle: String, copyButtonTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.copyButtonTitle = copyButtonTitle
    }
}

class AddressViewDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = {
        var options = [TweakingOption]()

        options.append(TweakingOption(title: "Address data") {
            let location = CLLocationCoordinate2D(latitude: 65.10915470111108, longitude: 11.984673996759456)
            self.addressView.model = AddressViewData(title: "Møllerøya 32", subtitle: "7982 Bindalseidet", copyButtonTitle: "Kopier adresse")
            self.addressView.configureAnnotation(title: "Møllerøya 32, 7982 Bindalseidet", location: location)
            self.addressView.centerMap(location: location, regionDistance: 500, animated: false)
        })

        options.append(TweakingOption(title: "Postalcode data") {
            let location = CLLocationCoordinate2D(latitude: 59.925504072875661, longitude: 10.452107618894244)
            self.addressView.model = AddressViewData(title: "1340", subtitle: "Skui", copyButtonTitle: "Kopier postnummer")
            self.addressView.configureRadiusArea(500, location: location)
            self.addressView.centerMap(location: location, regionDistance: 1200, animated: false)
        })

        let polygonDemoData = [
            PolygonDemoData(title: "0010", subtitle: "OSLO", areas: [PolygonDemoArea.area0010]),
            PolygonDemoData(title: "Multi polygons", subtitle: "OSLO", areas: [PolygonDemoArea.area0010, PolygonDemoArea(coordinates: [[10.74, 59.92], [10.75, 59.92], [10.74, 59.91]])])
        ]
        polygonDemoData.forEach({
            let postalCode = $0.title
            let postalAreaName = $0.subtitle
            let areas = $0.areas
            options.append(TweakingOption(title: "Postalcode shape (\(postalCode))") {
                self.addressView.model = AddressViewData(title: postalCode, subtitle: postalAreaName, copyButtonTitle: "Kopier postnummer")
                self.addressView.configurePolygons(areas.compactMap({ $0?.coordinates }))
            })
        })
        return options
    }()

    private lazy var addressView: AddressView = {
        let addressView = AddressView(withAutoLayout: true)
        addressView.delegate = self
        return addressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(addressView)
        addressView.fillInSuperview()
        tweakingOptions.first?.action?()

        // Place a nice looking view in front of the mapView to prevent the UI tests from failing.
        for subview in addressView.subviews {
            guard let mapView = subview as? MKMapView else { break }
            let colorfulView = UIView(withAutoLayout: true)
            colorfulView.backgroundColor = .mint
            mapView.addSubview(colorfulView)
            colorfulView.fillInSuperview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak colorfulView] in
                colorfulView?.removeFromSuperview()
            })
        }
    }
}

extension AddressViewDemoView: AddressViewDelegate {
    func addressViewDidSelectCopyButton(_ addressView: AddressView) {
        print("addressViewDidSelectCopyButton")
    }

    func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView, sender: UIView) {
        print("addressViewDidSelectGetDirectionsButton")
    }

    func addressViewDidSelectCenterMapButton(_ addressView: AddressView) {
        print("addressViewDidSelectCenterMapButton")
        addressView.makePolygonOverlayVisible()
    }

    func addressView(_ addressView: AddressView, didSelectMapTypeAtIndex index: Int) {
        guard let mapType = MapTypes(rawValue: index) else { return }
        switch mapType {
        case .standard:
            addressView.changeMapType(.standard)
        case .satellite:
            addressView.changeMapType(.satellite)
        case .hybrid:
            addressView.changeMapType(.hybrid)
        }
    }
}

private struct PolygonDemoData {
    let title: String
    let subtitle: String
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
