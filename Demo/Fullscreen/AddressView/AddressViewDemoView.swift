//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import MapKit

enum MapTypes: Int, CaseIterable {
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

public struct AddressViewData: AddressViewModel {
    public var mapTypes: [String] {
        return MapTypes.allCases.map { $0.value }
    }
    public var title: String
    public var subtitle: String
    public var copyButtonTitle: String
    public var selectedMapType = 0
    public var getDirectionsButtonTitle = "Åpne veibeskrivelse"

    public init(title: String, subtitle: String, copyButtonTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.copyButtonTitle = copyButtonTitle
    }
}

public class AddressViewDemoView: UIView, Tweakable {
    private enum AddressViewDemoError: Error {
        case decodingError
    }

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

        let coordinatesFor0010 = [[10.7244, 59.9181], [10.7252, 59.9185], [10.7264, 59.9192], [10.727099999999998, 59.919799999999995], [10.7274, 59.92], [10.727899999999998, 59.9202], [10.728499999999999, 59.9199], [10.7294, 59.919599999999996], [10.730299999999998, 59.9192], [10.729899999999999, 59.9184], [10.731199999999998, 59.917399999999994], [10.732099999999999, 59.9173], [10.7326, 59.917199999999994], [10.734699999999998, 59.9165], [10.734299999999998, 59.9161], [10.733899999999998, 59.9159], [10.7334, 59.9156], [10.7327, 59.9154], [10.730899999999998, 59.9153], [10.730199999999998, 59.9153], [10.7294, 59.9154], [10.728399999999999, 59.9154], [10.7266, 59.9154], [10.7252, 59.9155], [10.723999999999998, 59.9154], [10.723299999999998, 59.9154], [10.7228, 59.9154], [10.7227, 59.9157], [10.7228, 59.9161], [10.7229, 59.9163], [10.722999999999999, 59.916799999999995], [10.722999999999999, 59.916999999999994], [10.7234, 59.9173], [10.7244, 59.9181]]
        let polygonDemoData = [
            ["0010", "OSLO", [coordinatesFor0010]],
            ["Multi polygons", "OSLO", [coordinatesFor0010, [[10.74, 59.92], [10.75, 59.92], [10.74, 59.91]]]]
        ]
        polygonDemoData.forEach({
            let postalCode = ($0[0] as? String) ?? ""
            let postalAreaName = ($0[1] as? String) ?? ""
            let areas = ($0[2] as? [[[Double]]]) ?? [[[Double]]]()
            options.append(TweakingOption(title: "Postalcode shape (\(postalCode))") {
                self.addressView.model = AddressViewData(title: postalCode, subtitle: postalAreaName, copyButtonTitle: "Kopier postnummer")
                var parsedAreas = [[CLLocationCoordinate2D]]()
                areas.forEach({
                    guard let parsedCoordinates = try? $0.map({ (degreesArray) -> CLLocationCoordinate2D in
                        guard degreesArray.count == 2, let lat = degreesArray.last, let lon = degreesArray.first else {
                            throw AddressViewDemoError.decodingError
                        }
                        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    }) else {
                        return
                    }
                    parsedAreas.append(parsedCoordinates)
                })

                self.addressView.configurePolygons(parsedAreas)
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

    public required init?(coder aDecoder: NSCoder) { fatalError() }

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
    public func addressViewDidSelectCopyButton(_ addressView: AddressView) {
        print("addressViewDidSelectCopyButton")
    }

    public func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView, sender: UIView) {
        print("addressViewDidSelectGetDirectionsButton")
    }

    public func addressViewDidSelectCenterMapButton(_ addressView: AddressView) {
        print("addressViewDidSelectCenterMapButton")
        addressView.makePolygonOverlayVisible()
    }

    public func addressView(_ addressView: AddressView, didSelectMapTypeAtIndex index: Int) {
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
