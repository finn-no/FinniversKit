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

    public weak var delegate: FavoriteButtonViewDelegate?

    // MARK: - Private properties

    private var viewModel: FavoriteButtonViewModel?
    private let flatButtonStyle = Button.Style.flat.overrideStyle(margins: UIEdgeInsets.zero)

    private lazy var button: Button = {
        let button = Button(style: flatButtonStyle, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(leading: .spacingS)
        button.imageEdgeInsets = UIEdgeInsets(top: -.spacingXS)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.contentHorizontalAlignment = .leading
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [button, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSubtle
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: FavoriteButtonViewModel) {
        self.viewModel = viewModel

        button.setTitle(viewModel.title, for: .normal)
        subtitleLabel.text = viewModel.subtitle
        let image = viewModel.isFavorite ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .backgroundPrimary
    }

    // MARK: - Private methods

    @objc private func handleButtonTap() {
        guard let viewModel = viewModel else { return }
        delegate?.favoriteButtonDidSelect(self, button: button, viewModel: viewModel)
    }
}
