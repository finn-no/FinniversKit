//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc public class AddressView: UIView {
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
        backgroundColor = .red

        NSLayoutConstraint.activate([
        ])
    }
}
