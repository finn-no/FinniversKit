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
