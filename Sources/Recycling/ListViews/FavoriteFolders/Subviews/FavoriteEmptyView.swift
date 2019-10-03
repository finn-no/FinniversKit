//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteEmptyViewDelegate: AnyObject {
    func favoriteEmptyViewDidSelectButton(_: FavoriteEmptyView)
}

final class FavoriteEmptyView: UIView {

    // MARK: - Public properties

    weak var delegate: FavoriteEmptyViewDelegate?

    // MARK: - Private properties

    private lazy var wrapperView = UIView(withAutoLayout: true)
    private lazy var wrapperViewBottomConstraint = wrapperView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -windowSafeAreaInsets.bottom)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private lazy var magnifyingGlassImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .magnifyingGlass)
        return imageView
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var addFolderButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .bodyStrong
        button.setImage(UIImage(named: .plusMini), for: .normal)
        button.setTitleColor(.primaryBlue, for: .normal)
        button.setTitleColor(.flatButtonHighlightedTextColor, for: .highlighted)
        button.setTitleColor(.flatButtonHighlightedTextColor, for: .selected)
        button.addTarget(self, action: #selector(handleAddFolderButtonTap), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -.smallSpacing, bottom: 0, right: .smallSpacing)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: .smallSpacing, bottom: 0, right: 0)
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
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)

        clipsToBounds = true
        backgroundColor = .milk

        stackView.addArrangedSubview(magnifyingGlassImageView)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(addFolderButton)

        stackView.setCustomSpacing(.mediumSpacing, after: magnifyingGlassImageView)
        stackView.setCustomSpacing(.mediumLargeSpacing, after: bodyLabel)

        wrapperView.addSubview(stackView)
        addSubview(wrapperView)

        NSLayoutConstraint.activate([
            wrapperView.topAnchor.constraint(equalTo: topAnchor),
            wrapperView.leadingAnchor.constraint(equalTo: leadingAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: trailingAnchor),
            wrapperViewBottomConstraint,

            stackView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: .veryLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -.veryLargeSpacing),

            magnifyingGlassImageView.heightAnchor.constraint(equalToConstant: 48),
            magnifyingGlassImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Private methods

    @objc private func handleAddFolderButtonTap() {
        delegate?.favoriteEmptyViewDidSelectButton(self)
    }

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: wrapperView)
        let wrapperBottomOffset = keyboardIntersection + windowSafeAreaInsets.bottom

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.wrapperViewBottomConstraint.constant = -wrapperBottomOffset
            self?.layoutIfNeeded()
        }
    }

    // MARK: - Public methods

    func configure(withText text: String, buttonTitle: String?) {
        addFolderButton.setTitle(buttonTitle, for: .normal)
        addFolderButton.isHidden = buttonTitle == nil

        bodyLabel.text = text
    }
}
