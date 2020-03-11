//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteButtonViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var isFavorite: Bool { get }
}

public protocol FavoriteButtonViewDelegate: AnyObject {
    func favoriteButtonDidSelect(_ favoriteButtonView: FavoriteButtonView, button: Button, viewModel: FavoriteButtonViewModel)
}

public class FavoriteButtonView: UIView {

    // MARK: - Public properties

    public var delegate: FavoriteButtonViewDelegate?

    // MARK: - Private properties

    private var viewModel: FavoriteButtonViewModel?
    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .btnDisabled)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [button, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.spacing = .verySmallSpacing
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
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
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

    public func configure(with viewModel: FavoriteButtonViewModel) {
        self.viewModel = viewModel

        button.setTitle(viewModel.title, for: .normal)

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle?.isEmpty ?? true

        let buttonImage = viewModel.isFavorite ? UIImage(named: .favouriteAdded) : UIImage(named: .favoriteAdd)
        button.setImage(buttonImage, for: .normal)
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.favoriteButtonDidSelect(self, button: button, viewModel: viewModel)
    }
}
