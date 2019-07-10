//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import MapKit

public protocol AddressViewDelegate: class {
    func addressViewDidSelectCopyButton(_ addressView: AddressView)
    func addressViewDidSelectGetDirectionsButton(_ addressView: AddressView)
    func addressViewDidSelectCenterMapButton(_ addressView: AddressView)
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

    private lazy var centerMapButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.backgroundColor = .milk
        button.tintColor = .primaryBlue

        button.layer.cornerRadius = 23
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.5

        button.setImage(UIImage(named: .pin), for: .normal)
        button.setImage(UIImage(named: .pin), for: .highlighted)
        button.addTarget(self, action: #selector(centerMapButtonAction), for: .touchUpInside)

        return button
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
            mapTypeSegmentControl.selectedSegmentIndex = model.selectedMapType

            addressCardView.titleLabel.text = model.title
            addressCardView.subtitleLabel.text = model.subtitle
            addressCardView.copyButton.setTitle(model.copyButtonTitle, for: .normal)
            addressCardView.getDirectionsButton.setTitle(model.getDirectionsButtonTitle, for: .normal)
        }
    }
}

// MARK: - Private methods

private extension AddressView {
    private func setup() {
        addSubview(segmentContainer)
        insertSubview(mapView, belowSubview: segmentContainer)
        addSubview(addressCardView)
        addSubview(centerMapButton)

        NSLayoutConstraint.activate([
            segmentContainer.topAnchor.constraint(equalTo: topAnchor),
            segmentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            mapView.topAnchor.constraint(equalTo: segmentContainer.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: addressCardView.topAnchor, constant: .mediumLargeSpacing),

            centerMapButton.bottomAnchor.constraint(equalTo: addressCardView.topAnchor, constant: -.mediumSpacing),
            centerMapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            centerMapButton.widthAnchor.constraint(equalToConstant: 46),
            centerMapButton.heightAnchor.constraint(equalTo: centerMapButton.widthAnchor),

            addressCardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            addressCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            addressCardView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }

    @objc func mapTypeChanged() {
        delegate?.addressView(self, didSelectMapTypeAtIndex: mapTypeSegmentControl.selectedSegmentIndex)
    }

    @objc func centerMapButtonAction() {
        delegate?.addressViewDidSelectCenterMapButton(self)
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
