//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct AddressViewDefaultData: AddressViewModel {
    public var title = "Hva gjelder det?"

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
