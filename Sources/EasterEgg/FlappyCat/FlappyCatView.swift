//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SpriteKit

public class FlappyCatView: UIView {
    lazy var skView: SKView = {
        let view = SKView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(skView)
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: topAnchor),
            skView.bottomAnchor.constraint(equalTo: bottomAnchor),
            skView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])

        let scene = FlappyCatScene(size: UIScreen.main.bounds.size)
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
}
