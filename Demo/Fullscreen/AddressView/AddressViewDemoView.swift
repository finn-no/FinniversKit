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

public class AddressViewDemoView: UIView {
    weak var presentingViewController: UIViewController?

    let defaultAddressData = AddressViewData(title: "Møllerøya 32", subtitle: "7982 Bindalseidet", copyButtonTitle: "Kopier adresse")

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

        self.addressView.model = self.defaultAddressData
        let location = CLLocationCoordinate2D(latitude: 65.10915470111108, longitude: 11.984673996759456)
        self.addressView.addAnnotation(location: location, title: "Møllerøya 32, 7982 Bindalseidet")
        self.addressView.centerMap(location: location, regionDistance: 500, animated: false)
    }
}

extension AddressViewDemoView: AddressViewDelegate {
    public func addressViewDidSelectCopyButton(_ addressView: AddressView) {
        print("addressViewDidSelectCopyButton")
    }

    public func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView) {
        print("addressViewDidSelectGetDirectionsButton")
    }

    public func addressViewDidSelectCenterMapButton(_ addressView: AddressView) {
        print("addressViewDidSelectCenterMapButton")
    }

    public func addressView(_ addressView: AddressView, didSelectMapTypeAtIndex index: Int) {
        guard let mapType = MapTypes(rawValue: index) else { return }
        switch mapType {
        case .standard:
            addressView.changeMapType(mapType: .standard)
        case .satellite:
            addressView.changeMapType(mapType: .satellite)
        case .hybrid:
            addressView.changeMapType(mapType: .hybrid)
        }
    }
}
