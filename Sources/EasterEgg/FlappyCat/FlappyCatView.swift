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

    private lazy var backButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        button.layer.borderColor = UIColor(hex: "FF8CA1").cgColor
        button.layer.backgroundColor = UIColor(hex: "FFCED7").cgColor
        button.setTitle("Tilbake", for: .normal)
        button.setTitleColor(.licorice, for: .normal)
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(skView)
        addSubview(backButton)
        NSLayoutConstraint.activate([
            skView.topAnchor.constraint(equalTo: topAnchor),
            skView.bottomAnchor.constraint(equalTo: bottomAnchor),
            skView.trailingAnchor.constraint(equalTo: trailingAnchor),
            skView.leadingAnchor.constraint(equalTo: leadingAnchor),

            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .veryLargeSpacing),
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.veryLargeSpacing),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing)
            ])

        let scene = FlappyCatScene(size: UIScreen.main.bounds.size)
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

    @objc func backButtonPressed(sender button: UIButton) {
        
    }
}
