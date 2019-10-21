//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderXmasViewDelegate: AnyObject {
    func favoriteFolderXmasViewDidTap(_ view: FavoriteFolderXmasView)
}

public final class FavoriteFolderXmasView: UIView {
    public weak var delegate: FavoriteFolderXmasViewDelegate?

    public var calloutText = "" {
        didSet {
            calloutView.isHidden = calloutText.isEmpty
            calloutView.show(withText: calloutText)
        }
    }

    private lazy var button: FloatingButton = {
        let button = FloatingButton.favoritesXmasButton()
        button.isUserInteractionEnabled = false
        return button
    }()

    private lazy var calloutView: CalloutView = {
        let view = CalloutView(direction: .down, arrowAlignment: .right(24))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.4)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        addSubview(button)
        addSubview(calloutView)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            button.widthAnchor.constraint(equalToConstant: .veryLargeSpacing),
            button.heightAnchor.constraint(equalTo: button.widthAnchor),

            calloutView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -.mediumSpacing),
            calloutView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            calloutView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
        ])
    }

    // MARK: - Actions

    @objc private func handleTap() {
        delegate?.favoriteFolderXmasViewDidTap(self)
    }
}
