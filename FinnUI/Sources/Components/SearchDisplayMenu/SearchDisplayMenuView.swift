//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SearchDisplayMenuViewDelegate: AnyObject {
    func searchDisplayMenuViewDidSelectSort()
    func searchDisplayMenuViewDidSelectChangeDisplayType()
}

public class SearchDisplayMenuView: UIView {
    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var sortImageView: UIImageView =
        createTappableImageView(with: UIImage(named: .sort), action: #selector(sortButtonTapped))

    private lazy var changeDisplayTypeImageView: UIImageView =
        createTappableImageView(with: UIImage(named: .pin), action: #selector(changeDisplayTypeButtonTapped))

    // MARK: - Public properties

    public weak var delegate: SearchDisplayMenuViewDelegate?
    public static let height: CGFloat = 44

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
        backgroundColor = .bgPrimary
        layer.cornerRadius = 22
        layer.borderWidth = 0.5

        addSubview(separatorLine)
        addSubview(sortImageView)
        addSubview(changeDisplayTypeImageView)

        dropShadow(color: .textPrimary, opacity: 0.20, offset: CGSize(width: 0, height: 4.5), radius: 13)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 128),
            heightAnchor.constraint(equalToConstant: SearchDisplayMenuView.height),

            sortImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXXS),
            sortImageView.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            sortImageView.topAnchor.constraint(equalTo: topAnchor),
            sortImageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            separatorLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.widthAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),

            changeDisplayTypeImageView.leadingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            changeDisplayTypeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXXS),
            changeDisplayTypeImageView.topAnchor.constraint(equalTo: topAnchor),
            changeDisplayTypeImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func createTappableImageView(with image: UIImage, action: Selector) -> UIImageView {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.insertImageWithPaddings(image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = .borderColor
    }

    // MARK: - Actions

    @objc private func sortButtonTapped() {
        delegate?.searchDisplayMenuViewDidSelectSort()
    }

    @objc private func changeDisplayTypeButtonTapped() {
        delegate?.searchDisplayMenuViewDidSelectChangeDisplayType()
    }
}

// MARK: - Private extensions

private extension UIImageView {

    private static let verticalIconPadding: CGFloat = .spacingS + .spacingXXS

    func insertImageWithPaddings(_ image: UIImage) {
        self.image = image
            .withAlignmentRectInsets(UIEdgeInsets(
                top: -UIImageView.verticalIconPadding,
                bottom: -UIImageView.verticalIconPadding))
            .withRenderingMode(.alwaysTemplate)
    }
}

private extension CGColor {
    class var borderColor: CGColor {
        UIColor.dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine).cgColor
    }
}
