//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

final class ExtendedProfileDemoView: UIView {
    private lazy var view: ExtendedProfileView = {
        let view = ExtendedProfileView()
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
