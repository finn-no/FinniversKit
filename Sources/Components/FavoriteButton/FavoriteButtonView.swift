//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct FavoriteButtonViewModel {
    let title: String
    let subtitle: String?
    let isFavorited: Bool

    public init(title: String, subtitle: String?, isFavorited: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isFavorited = isFavorited
    }
}

public protocol FavoriteButtonViewDelegate: AnyObject {
    func favoriteButtonDidSelect(_ button: FavoriteButtonView)
}

public class FavoriteButtonView: UIView {

    // MARK: - Public properties

    public var delegate: FavoriteButtonViewDelegate?

    // MARK: - Private properties

    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .btnDisabled)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [button, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var button: Button = {
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.contentEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: .smallSpacing)
        button.imageEdgeInsets = UIEdgeInsets(leading: -.mediumSpacing)
        button.titleEdgeInsets = UIEdgeInsets(leading: .mediumSpacing)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(withTitle title: String, subtitle: String?, isFavorited: Bool) {
        button.setTitle(title, for: .normal)

        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle?.isEmpty ?? true

        let buttonImage = isFavorited ? UIImage(named: .favouriteAdded) : UIImage(named: .favoriteAdd)
        button.setImage(buttonImage, for: .normal)
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        delegate?.favoriteButtonDidSelect(self)
    }
}
