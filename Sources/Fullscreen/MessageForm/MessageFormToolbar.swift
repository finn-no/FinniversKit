//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

class MessageFormToolbar: UIView {

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        backgroundColor = .sardine

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44.0)
        ])
    }
}
