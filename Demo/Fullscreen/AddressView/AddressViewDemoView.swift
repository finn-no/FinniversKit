//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

enum MapModes: String, CaseIterable {
    case map = "Kart"
    case satellite = "Flyfoto"
    case hybrid = "Hybrid"
}

public struct AddressViewDefaultData: AddressViewModel {
    public var mapModes: [String] {
        return MapModes.allCases.map { $0.rawValue }
    }
    public var selectedMapMode = 0
    public var address = "Vadmyrveien 18"
    public var postalCode = "5172 Loddefjord"
    public var secondaryActionTitle = "Kopier adresse"
    public var primaryActionTitle = "Åpne veibeskrivelse"

    public init() {}
}

public class AddressViewDemoView: UIView {
    private lazy var addressView: AddressView = {
        let addressView = AddressView()
        addressView.translatesAutoresizingMaskIntoConstraints = false
        return addressView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addressView.model = AddressViewDefaultData()

        addSubview(addressView)

        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: topAnchor),
            addressView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
