//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SearchDisplayMenuViewDelegate: AnyObject {
    func searchDisplayMenuViewDidSelectSort()
    func searchDisplayMenuViewDidSelectChangeDisplay()
}

public class SearchDisplayMenuView: UIView {

    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var sortImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.insertImageWithPaddings(UIImage(named: .sort))
        return imageView
    }()

    private lazy var changeDisplayImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeDisplayButtonTapped))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        imageView.insertImageWithPaddings(UIImage(named: .pin))
        return imageView
    }()

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
        addSubview(changeDisplayImageView)

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

            changeDisplayImageView.leadingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            changeDisplayImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXXS),
            changeDisplayImageView.topAnchor.constraint(equalTo: topAnchor),
            changeDisplayImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
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

    @objc private func changeDisplayButtonTapped() {
        delegate?.searchDisplayMenuViewDidSelectChangeDisplay()
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
