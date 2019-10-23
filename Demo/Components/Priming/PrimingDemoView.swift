//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PrimingDemoView: UIView {
    private lazy var view = UIView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 337),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
