//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc public class AddressView: UIView {
    lazy var mapTypeSegmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Kart", "Flyfoto", "Hybrid"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        NSLayoutConstraint.activate([
            mapTypeSegmentControl.topAnchor.constraint(equalTo: topAnchor),
            mapTypeSegmentControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            mapTypeSegmentControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
