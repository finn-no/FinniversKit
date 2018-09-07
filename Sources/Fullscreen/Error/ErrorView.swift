//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - LoginViewDelegatew

public protocol ErrorViewDelegate: NSObjectProtocol {
    func errorView(_ errorView: ErrorView, didPressTryAgainButton button: Button)
    func errorView(_ errorView: ErrorView, didPressPlayButton button: Button)
}

public class ErrorView: UIView {
    // MARK: - Internal properties

    private lazy var catImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: .failureCat)
        view.contentMode = .center
        return view
    }()

    private lazy var tryAgainButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tryAgainButtonPressed(sender:)), for: .touchUpInside)
        return button
    }()

    private lazy var playButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(playButtonPressed(sender:)), for: .touchUpInside)
        button.layer.borderColor = UIColor(hex: "FF8CA1").cgColor
        return button
    }()

    // MARK: - Dependency injection

    public var model: ErrorViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            tryAgainButton.setTitle(model.tryAgainButtonTitle, for: .normal)
            playButton.setTitle(model.playButtonTitle, for: .normal)
        }
    }

    // MARK: - External properties

    public weak var delegate: ErrorViewDelegate?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(catImageView)
        addSubview(tryAgainButton)
        addSubview(playButton)

        let image = UIImage(named: .failureCat)

        NSLayoutConstraint.activate([
            catImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -image.size.height),
            catImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tryAgainButton.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: .largeSpacing),
            tryAgainButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            tryAgainButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            playButton.topAnchor.constraint(equalTo: tryAgainButton.bottomAnchor, constant: .largeSpacing),
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func tryAgainButtonPressed(sender button: Button) {
        delegate?.errorView(self, didPressTryAgainButton: button)
    }

    @objc func playButtonPressed(sender button: Button) {
        delegate?.errorView(self, didPressPlayButton: button)
    }
}
