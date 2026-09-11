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

    private lazy var wrapperView = UIView(withAutoLayout: true)
    private lazy var wrapperViewBottomConstraint = wrapperView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -windowSafeAreaInsets.bottom
    )

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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardNotification),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )

        backgroundColor = .clear

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(addFolderButton)

        wrapperView.addSubview(stackView)
        addSubview(wrapperView)

        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperViewBottomConstraint,

            iconImageView.widthAnchor.constraint(equalToConstant: 64),
            iconImageView.heightAnchor.constraint(equalToConstant: 64),

            stackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: Warp.Spacing.spacing400),
            stackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -Warp.Spacing.spacing400),
            stackView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
        ])
    }

    // MARK: - Public methods

    func configure(withText text: String, buttonTitle: String?) {
        bodyLabel.text = text
        addFolderButton.setTitle(buttonTitle, for: .normal)
        addFolderButton.isHidden = buttonTitle == nil
    }

    // MARK: - Private methods

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: wrapperView)
        let wrapperBottomOffset = keyboardIntersection > 0
            ? keyboardIntersection + windowSafeAreaInsets.bottom
            : windowSafeAreaInsets.bottom
        wrapperViewBottomConstraint.constant = -wrapperBottomOffset

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.layoutIfNeeded()
        }
    }

    @objc private func handleAddFolderButtonTap() {
        delegate?.favoriteSearchEmptyViewDidSelectButton(self)
    }
}
