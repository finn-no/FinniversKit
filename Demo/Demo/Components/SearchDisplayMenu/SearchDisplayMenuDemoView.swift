//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

class SearchDisplayMenuDemoView: UIView {
    private lazy var view: SearchDisplayMenuView = {
        let view = SearchDisplayMenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
