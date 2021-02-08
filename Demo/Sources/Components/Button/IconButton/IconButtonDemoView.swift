//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import FinniversKit

public class IconButtonDemoView: UIView {

    private lazy var favoriteStyledButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var customStyledButton: IconButton = {
        let button = IconButton(style: .init(icon: UIImage(named: .emptyMoon), iconToggled: UIImage(named: .filledMoon)))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [favoriteStyledButton, customStyledButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
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
        addSubview(stackView)

        stackView.arrangedSubviews.forEach {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: 34),
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
            ])
        }

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func handleTap(_ sender: IconButton) {
        sender.isToggled.toggle()
    }
}
