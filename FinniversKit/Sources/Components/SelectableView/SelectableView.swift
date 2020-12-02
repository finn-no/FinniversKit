import UIKit

public protocol SelectableViewDelegate: AnyObject {
    func selectableViewWasTapped(_ selectableView: SelectableView)
}

public class SelectableView: UIView {

    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .iconPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let contentView: UIView

    public weak var delegate: SelectableViewDelegate?

    // MARK: - Init

    public init(withSubview view: UIView, withAutoLayout: Bool = false) {
        self.contentView = view
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgSecondary
        layer.cornerRadius = .spacingS

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)

        addSubview(arrowImageView)
        addSubview(contentView)

        let padding: CGFloat = .spacingM

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            contentView.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -padding),

            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding + .spacingXS)),
            arrowImageView.widthAnchor.constraint(equalToConstant: 7),
        ])
    }

    @objc private func handleTap() {
        delegate?.selectableViewWasTapped(self)
    }
}
