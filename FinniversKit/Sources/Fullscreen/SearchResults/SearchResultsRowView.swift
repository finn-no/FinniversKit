import Foundation

protocol SearchResultsRowViewDelegate: AnyObject {
    func searchResultsRowViewDidSelectButton(_ searchResultsRowView: SearchResultsRowView)
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
        imageView.image = icon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconColor
        return imageView
    }()

    private lazy var button: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private var icon: UIImage

    weak var delegate: SearchResultsRowViewDelegate?

    init(icon: UIImage) {
        self.icon = icon
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        fillInSuperview()
        addSubview(stackView)
        stackView.fillInSuperview()

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
    }

    func configure(with title: String) {
        button.setTitle(title, for: .normal)
    }

    @objc func buttonTapped() {
        delegate?.searchResultsRowViewDidSelectButton(self)
    }
}

private extension UIColor {
    class var iconColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }
}
