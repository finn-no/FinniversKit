import FinniversKit

protocol SearchResultsRowViewDelegate: AnyObject {
    func searchResultsRowViewDidSelectButton(_ searchResultsRowView: SearchResultsRowView)
    func searchResultsRowViewDidSelectDeleteButton(_ searchResultsRowView: SearchResultsRowView)
}

class SearchResultsRowView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconColor
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var button: Button = {
        let style = Button.Style.flat.overrideStyle(textColor: .textPrimary)
        let button = Button(style: style, withAutoLayout: true)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        button.contentHorizontalAlignment = .leading
        return button
    }()

    private lazy var deleteIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.tintColor = .iconColor

        let padding: CGFloat = 10
        imageView.image = UIImage(named: .remove)
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: -padding, left: -padding, bottom: -padding, right: -padding))

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteButtonTapped))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    weak var delegate: SearchResultsRowViewDelegate?

    // MARK: - Init

    init(viewModel: SearchResultsListViewModel) {
        super.init(frame: .zero)
        setup(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(with viewModel: SearchResultsListViewModel) {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        stackView.fillInSuperview()

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)

        if viewModel.showDeleteRowIcons {
            stackView.addArrangedSubview(deleteIconImageView)
        }
        imageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            deleteIconImageView.heightAnchor.constraint(equalToConstant: 44),
            deleteIconImageView.widthAnchor.constraint(equalTo: deleteIconImageView.heightAnchor),
        ])
    }

    // MARK: - Internal methods

    func configure(with text: String) {
        button.setTitle(text, for: .normal)
    }

    // MARK: - Actions

    @objc func buttonTapped() {
        delegate?.searchResultsRowViewDidSelectButton(self)
    }

    @objc func deleteButtonTapped() {
        delegate?.searchResultsRowViewDidSelectDeleteButton(self)
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var iconColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }
}
