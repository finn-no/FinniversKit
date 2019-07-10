//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

public protocol AddressViewDelegate: class {
    func addressViewDidSelectCopyButton(_ addressView: AddressView)
    func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView)
    func addressView(_ addressView: AddressView, didSelectMapTypeAtIndex index: Int)
}

@objc public class AddressView: UIView {
    public weak var delegate: AddressViewDelegate?

    private lazy var mapTypeSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [])
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        return control
    }()

    private lazy var segmentContainer: UIView = {
        let segmentContainer = UIView()
        segmentContainer.translatesAutoresizingMaskIntoConstraints = false
        segmentContainer.backgroundColor = .white
        segmentContainer.addSubview(mapTypeSegmentControl)
        segmentContainer.layer.masksToBounds = false
        segmentContainer.layer.shadowOpacity = 0.3
        segmentContainer.layer.shadowRadius = 3
        segmentContainer.layer.shadowOffset = .zero
        segmentContainer.layer.shadowColor = UIColor.black.cgColor

        NSLayoutConstraint.activate([
            mapTypeSegmentControl.topAnchor.constraint(equalTo: segmentContainer.topAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.leadingAnchor.constraint(equalTo: segmentContainer.leadingAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.trailingAnchor.constraint(equalTo: segmentContainer.trailingAnchor, constant: -.mediumLargeSpacing),
            mapTypeSegmentControl.bottomAnchor.constraint(equalTo: segmentContainer.bottomAnchor, constant: -.mediumLargeSpacing)
            ])

        return segmentContainer
    }()

    public private(set) lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var addressCardView: AddressCardView = {
        let view = AddressCardView()
        view.delegate = self
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

            for (index, segment) in model.mapTypes.enumerated() {
                mapTypeSegmentControl.insertSegment(withTitle: segment, at: index, animated: false)
            }
            mapTypeSegmentControl.selectedSegmentIndex = model.selectedMapMode

            addressCardView.titleLabel.text = model.address
            addressCardView.subtitleLabel.text = model.postalCode
            addressCardView.copyButton.setTitle(model.secondaryActionTitle, for: .normal)
            addressCardView.getDirectionsButton.setTitle(model.primaryActionTitle, for: .normal)
        }
    }
}

// MARK: - Private methods

private extension AddressView {
    private func setup() {
        addSubview(segmentContainer)
        insertSubview(mapView, belowSubview: segmentContainer)
        addSubview(addressCardView)

        NSLayoutConstraint.activate([
            segmentContainer.topAnchor.constraint(equalTo: topAnchor),
            segmentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            mapView.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: addressCardView.topAnchor, constant: .mediumLargeSpacing),

            addressCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressCardView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    @objc func mapTypeChanged() {
        delegate?.addressView(self, didSelectMapTypeAtIndex: mapTypeSegmentControl.selectedSegmentIndex)
    }
}

extension AddressView: AddressCardViewDelegate {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView) {
        delegate?.addressViewDidSelectCopyButton(self)
    }

    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView) {
        delegate?.addressViewDidSelectGetDirectionsButton(self)
    }
}
