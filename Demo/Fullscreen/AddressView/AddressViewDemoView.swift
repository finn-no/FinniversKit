//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

enum MapTypes: Int, CaseIterable {
    case map
    case satellite
    case hybrid

    var value: String {
        switch self {
        case .map: return "Kart"
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
    weak var presentingViewController: UIViewController?

    let defaultAddressData = AddressViewData(title: "Vadmyrveien 18", subtitle: "5172 Loddefjord", copyButtonTitle: "Kopier adresse")

    lazy var tweakingOptions: [TweakingOption] = {
        var options = [TweakingOption]()

        options.append(TweakingOption(title: "Address data", description: nil, action: { parentViewController in
            self.addressView.model = self.defaultAddressData
            parentViewController?.dismiss(animated: true, completion: nil)
        }))

        options.append(TweakingOption(title: "Postalcode data", description: nil, action: { parentViewController in
            self.addressView.model = AddressViewData(title: "0563", subtitle: "Oslo", copyButtonTitle: "Kopier postnummer")
            parentViewController?.dismiss(animated: true, completion: nil)
        }))

        return options
    }()

    private lazy var addressView: AddressView = {
        let addressView = AddressView()
        addressView.delegate = self
        addressView.translatesAutoresizingMaskIntoConstraints = false
        return addressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addressView.model = defaultAddressData
        addSubview(addressView)
        addressView.fillInSuperview()
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
        print("didSelectMapTypeAtIndex: \(MapTypes(rawValue: index)?.value ?? "None")")
    }
}
