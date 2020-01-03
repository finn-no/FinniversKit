//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FavoriteAdCommentInputViewDelegate: AnyObject {
    func favoriteAdCommentInputView(_ view: FavoriteAdCommentInputView, didChangeText text: String)
    func favoriteAdCommentInputView(_ view: FavoriteAdCommentInputView, didScroll scrollView: UIScrollView)
}

public final class FavoriteAdCommentInputView: UIView {
    public weak var delegate: FavoriteAdCommentInputViewDelegate?

    // MARK: - Private properties

    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private let commentViewModel: FavoriteAdCommentViewModel
    private let adViewModel: FavoriteAdViewModel
    private let notificationCenter: NotificationCenter
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var scrollView: UIScrollView = {
        let view = ScrollView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var adView: FavoriteAdView = {
        let view = FavoriteAdView(withAutoLayout: true)
        view.isMoreButtonHidden = true
        view.isCommentViewHidden = true
        view.configure(with: adViewModel)
        view.remoteImageViewDataSource = remoteImageViewDataSource
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.placeholderText = commentViewModel.placeholder
        textView.text = adViewModel.comment
        textView.isScrollEnabled = false
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textView
    }()

    private lazy var scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)

    // MARK: - Init

    public init(
        commentViewModel: FavoriteAdCommentViewModel,
        adViewModel: FavoriteAdViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        delegate: FavoriteAdCommentInputViewDelegate? = nil,
        notificationCenter: NotificationCenter = .default
    ) {
        self.commentViewModel = commentViewModel
        self.adViewModel = adViewModel
        self.remoteImageViewDataSource = remoteImageViewDataSource
        self.delegate = delegate
        self.notificationCenter = notificationCenter
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    public override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        let result = textView.resignFirstResponder()
        adView.resetContent()
        return result
    }

    // MARK: - Lifecycle

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        adView.loadImage()
    }

    // MARK: - Setup

    private func setup() {
        [UIResponder.keyboardWillHideNotification, UIResponder.keyboardWillShowNotification].forEach {
            notificationCenter.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: $0, object: nil)
        }

        addSubview(scrollView)

        scrollView.addSubview(contentView)
        contentView.addSubview(adView)
        contentView.addSubview(textView)
        contentView.fillInSuperview()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollViewBottomConstraint,

            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            adView.topAnchor.constraint(equalTo: contentView.topAnchor),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            textView.topAnchor.constraint(equalTo: adView.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 86),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
        ])

        updateScrollViewConstraint(withKeyboardVisible: false, keyboardOffset: 0)
    }

    // MARK: - Keyboard

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: self)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo, animations: { [weak self] in
            guard let self = self else { return }

            self.updateScrollViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self.layoutIfNeeded()
            self.delegate?.favoriteAdCommentInputView(self, didScroll: self.scrollView)
        })
    }

    private func updateScrollViewConstraint(withKeyboardVisible keyboardVisible: Bool, keyboardOffset: CGFloat) {
        let offset = keyboardOffset + windowSafeAreaInsets.bottom
        scrollViewBottomConstraint.constant = -offset
    }
}

// MARK: - UIScrollViewDelegate

extension FavoriteAdCommentInputView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.favoriteAdCommentInputView(self, didScroll: scrollView)
    }
}

// MARK: - TextViewDelegate

extension FavoriteAdCommentInputView: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
        delegate?.favoriteAdCommentInputView(self, didChangeText: textView.text)
    }
}

// MARK: - Private extensions

private final class ScrollView: UIScrollView {
    override var contentSize: CGSize {
        didSet {
            scrollToBottom()
        }
    }

    private func scrollToBottom() {
        let yOffset = contentSize.height - bounds.size.height + contentInset.bottom
        setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)
    }
}
