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
        imageView.addGestureRecognizer(
            UIGestureRecognizer(target: self, action: #selector(sortButtonTapped))
        )
        return imageView
    }()

    private lazy var changeDisplayImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
        imageView.addGestureRecognizer(
            UIGestureRecognizer(target: self, action: #selector(changeDisplayButtonTapped))
        )
        return imageView
    }()

    public weak var delegate: SearchDisplayMenuViewDelegate?

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
        layer.borderColor = .bgSecondary
        layer.borderWidth = 1

        addSubview(separatorLine)
        addSubview(sortImageView)
        addSubview(changeDisplayImageView)

//        dropShadow(color: .black, opacity: 0.12, offset: CGSize(width: 0, height: 1), radius: 4) // add a second shadow
        dropShadow(color: .black, opacity: 0.20, offset: CGSize(width: 0, height: 4.5), radius: 13)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 128),
            heightAnchor.constraint(equalToConstant: 44),

            sortImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortImageView.topAnchor.constraint(equalTo: topAnchor),
            sortImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            sortImageView.widthAnchor.constraint(equalToConstant: 64),

            changeDisplayImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            changeDisplayImageView.topAnchor.constraint(equalTo: topAnchor),
            changeDisplayImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            changeDisplayImageView.widthAnchor.constraint(equalToConstant: 64),

            separatorLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.widthAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),
        ])
    }

    // MARK: - Public methods

    public func configure(sortIcon: UIImage, changeDisplayIcon: UIImage) {
        sortImageView.insertImageWithPaddings(sortIcon)
        changeDisplayImageView.insertImageWithPaddings(changeDisplayIcon)
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
