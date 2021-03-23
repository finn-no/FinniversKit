import Foundation

public protocol PromoLinkViewDelegate: AnyObject {
    func promoLinkViewWasTapped(_ promoLinkView: PromoLinkView)
}

public protocol PromoLinkViewModel: AnyObject {
    var title: String { get }
    var image: UIImage { get }
}

public class PromoLinkView: UIView {

    private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView =  {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var navigationLinkView: NavigationLinkView = {
        let view = NavigationLinkView(withSubview: stackView, padding: .spacingS, backgroundColor: .bgTertiary)
        view.delegate = self
        return view
    }()

    private weak var delegate: PromoLinkViewDelegate?

    // MARK: - Init

    public init(delegate: PromoLinkViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgSecondary
        layer.cornerRadius = .spacingS

        addSubview(navigationLinkView)
        navigationLinkView.fillInSuperview()

        stackView.addArrangedSubviews([imageView, titleLabel])

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: PromoLinkViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        navigationLinkView.setAccessibilityLabel(viewModel.title)
    }
}

extension PromoLinkView: NavigationLinkViewDelegate {
    public func navigationLinkViewWasTapped(_ navigationLinkView: NavigationLinkView) {
        delegate?.promoLinkViewWasTapped(self)
    }
}
