import UIKit

public protocol NavigationLinkViewDelegate: AnyObject {
    func navigationLinkViewWasTapped(_ navigationLinkView: NavigationLinkView)
}

public class NavigationLinkView: UIView {

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let padding: CGFloat

    public weak var delegate: NavigationLinkViewDelegate?

    // MARK: - Init

    public init(
        withSubview view: UIView,
        withAutoLayout: Bool = false,
        padding: CGFloat = .spacingM,
        backgroundColor: UIColor = .bgSecondary
    ) {
        self.padding = padding
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        self.backgroundColor = backgroundColor
        setup(withSubview: view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup(withSubview view: UIView) {
        layer.cornerRadius = .spacingS

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)

        addSubview(arrowImageView)
        addSubview(view)

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            view.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -padding),

            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding + .spacingXS)),
            arrowImageView.widthAnchor.constraint(equalToConstant: 7),
        ])
    }

    // MARK: - Public methods

    public func setAccessibilityLabel(_ accessibilityLabel: String) {
        self.accessibilityLabel = accessibilityLabel
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    // MARK: - Actions

    @objc private func handleTap() {
        delegate?.navigationLinkViewWasTapped(self)
    }
}
