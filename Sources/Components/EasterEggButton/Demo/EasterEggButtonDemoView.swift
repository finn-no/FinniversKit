//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class EasterEggButtonDemoView: UIView {
    private lazy var easterEggButton: EasterEggButton = {
        let button = EasterEggButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(easterEggButton)

        NSLayoutConstraint.activate([
            easterEggButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            easterEggButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            easterEggButton.widthAnchor.constraint(equalToConstant: 64),
            easterEggButton.heightAnchor.constraint(equalToConstant: 64)
        ])
    }
}
