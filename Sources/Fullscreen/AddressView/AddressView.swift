//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

@objc public class AddressView: UIView {
    lazy var mapTypeSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Kart", "Flyfoto", "Hybrid"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var addressCardView: AddressCardView = {
        let view = AddressCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public var model: AddressViewModel? {
        didSet {
            guard let model = model else { return }
            print(model.title)
        }
    }
}

// MARK: - Private methods

private extension AddressView {
    private func setup() {
        addSubview(mapTypeSegmentControl)
        addSubview(mapView)
        addSubview(addressCardView)

        NSLayoutConstraint.activate([
            mapTypeSegmentControl.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            mapView.topAnchor.constraint(equalTo: mapTypeSegmentControl.bottomAnchor, constant: .mediumLargeSpacing),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),

            addressCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressCardView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
}
