//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FloatingButtonDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = {
        return [
            TweakingOption(title: "Hide badge") {
                self.floatingButton.itemsCount = 0
            },
            TweakingOption(title: "Show badge") {
                self.floatingButton.itemsCount = 10
            }
        ]
    }()

    private lazy var floatingButton: FloatingButton = {
        let button = FloatingButton()
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
        addSubview(floatingButton)

        NSLayoutConstraint.activate([
            floatingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            floatingButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            floatingButton.widthAnchor.constraint(equalToConstant: .veryLargeSpacing),
            floatingButton.heightAnchor.constraint(equalToConstant: .veryLargeSpacing)
        ])
    }
}
