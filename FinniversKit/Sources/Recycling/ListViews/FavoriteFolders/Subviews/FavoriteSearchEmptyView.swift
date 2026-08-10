//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol FavoriteSearchEmptyViewDelegate: AnyObject {
    func favoriteSearchEmptyViewDidSelectButton(_: FavoriteSearchEmptyView)
}

final class FavoriteSearchEmptyView: UIView {

    // MARK: - Public properties

    weak var delegate: FavoriteSearchEmptyViewDelegate?

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = Warp.Spacing.spacing200
        return stack
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Warp.UIToken.iconSubtle
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title3
        label.textColor = Warp.UIToken.text
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var addFolderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .bodyStrong
        button.setImage(UIImage(named: .plusMini), for: .normal)
        button.tintColor = Warp.UIToken.textLink
        button.setTitleColor(Warp.UIToken.textLink, for: .normal)
        button.addTarget(self, action: #selector(handleAddFolderButtonTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        // Transparent so anything behind (e.g. the folder title header) shows through.
        backgroundColor = .clear

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(addFolderButton)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),

            // Pin leading/trailing so the label has a width to wrap in, and
            // center the whole stack vertically inside the empty view.
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    // MARK: - Public methods

    func configure(withText text: String, buttonTitle: String?) {
        bodyLabel.text = text
        addFolderButton.setTitle(buttonTitle, for: .normal)
        addFolderButton.isHidden = buttonTitle == nil
    }

    // MARK: - Private methods

    @objc private func handleAddFolderButtonTap() {
        delegate?.favoriteSearchEmptyViewDidSelectButton(self)
    }
}
