//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol IconLinkViewDelegate: AnyObject {
    func iconLinkViewWasSelected(_ view: IconLinkView, url: String, identifier: String?)
}

public class IconLinkView: UIView {

    // MARK: - Public properties

    public weak var delegate: IconLinkViewDelegate?

    // MARK: - Private properties

    private var viewModel: IconLinkViewModel?
    private var iconImageViewSizeConstraints = [NSLayoutConstraint]()

    private lazy var titleLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.textColor = .linkTintColor
        label.numberOfLines = 0
        return label
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .linkTintColor
        return imageView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        addSubview(titleLabel)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: .spacingS),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingS),

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: .spacingS),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.spacingS),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: IconLinkViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)

        NSLayoutConstraint.deactivate(iconImageViewSizeConstraints)
        iconImageViewSizeConstraints = [
            iconImageView.widthAnchor.constraint(equalToConstant: viewModel.icon.size.width),
            iconImageView.heightAnchor.constraint(equalToConstant: viewModel.icon.size.height)
        ]
        NSLayoutConstraint.activate(iconImageViewSizeConstraints)
    }

    // MARK: - Actions

    @objc private func handleTap() {
        guard let url = viewModel?.url else { return }
        delegate?.iconLinkViewWasSelected(self, url: url, identifier: viewModel?.identifier)
    }
}

// MARK: - Private extension

private extension UIColor {
    static var linkTintColor = dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#006DFB"))
}
