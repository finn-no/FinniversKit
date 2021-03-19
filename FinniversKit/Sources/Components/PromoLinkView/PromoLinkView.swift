import Foundation

public protocol PromoLinkViewDelegate: AnyObject {
    func promoLinkViewWasTapped(_ promoLinkView: PromoLinkView)
}

public protocol PromoLinkViewModel: AnyObject {
    var title: String { get }
    var image: UIImage { get }
}

public class PromoLinkView: UIView {

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView =  {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var arrowIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: .arrowRight)
        return imageView
    }()

    private let verticalSpacing: CGFloat = .spacingL

    private weak var delegate: PromoLinkViewDelegate?

    // MARK: - Init

    public init(delegate: PromoLinkViewDelegate) {
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

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)

        isAccessibilityElement = true
        accessibilityTraits = .button

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(arrowIconImageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            imageView.heightAnchor.constraint(equalToConstant: 36),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingL),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowIconImageView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalSpacing),

            arrowIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            arrowIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: PromoLinkViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        accessibilityLabel = viewModel.title
    }

    // MARK: - Actions

    @objc func handleTap() {
        delegate?.promoLinkViewWasTapped(self)
    }
}
