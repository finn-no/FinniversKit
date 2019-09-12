//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FavoriteAdCommentViewControllerDelegate: AnyObject {
    func favoriteAdCommentViewControllerDidSelectCancel(_ viewController: FavoriteAdCommentViewController)
    func favoriteAdCommentViewController(_ viewController: FavoriteAdCommentViewController, didSelectSaveWithText text: String?)
}

final class FavoriteAdCommentViewController: UIViewController {
    weak var delegate: FavoriteAdCommentViewControllerDelegate?

    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private let commentViewModel: FavoriteAdCommentViewModel
    private let adViewModel: FavoriteAdViewModel
    private let adImage: UIImage?
    private let notificationCenter: NotificationCenter

    private lazy var cancelButton = UIBarButtonItem(
        title: commentViewModel.cancelButtonText,
        style: .plain,
        target: self,
        action: #selector(handleCancelButtonTap)
    )

    private lazy var saveButton = UIBarButtonItem(
        title: commentViewModel.saveButtonText,
        style: .done,
        target: self,
        action: #selector(handleSaveButtonTap)
    )

    private lazy var shadowView = BottomShadowView(withAutoLayout: true)
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
        view.remoteImageViewDataSource = self
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.text = adViewModel.comment
        textView.placeholderText = commentViewModel.placeholder
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textView
    }()

    private lazy var scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

    // MARK: - Init

    init(
        commentViewModel: FavoriteAdCommentViewModel,
        adViewModel: FavoriteAdViewModel,
        adImage: UIImage?,
        notificationCenter: NotificationCenter = .default
    ) {
        self.commentViewModel = commentViewModel
        self.adViewModel = adViewModel
        self.adImage = adImage
        self.notificationCenter = notificationCenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = commentViewModel.title
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton

        setup()
        saveButton.isEnabled = false

        [UIResponder.keyboardWillHideNotification, UIResponder.keyboardWillShowNotification].forEach {
            notificationCenter.addObserver(self, selector: #selector(handleKeyboardNotification(_:)), name: $0, object: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adView.loadImage()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = textView.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _ = textView.resignFirstResponder()
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(scrollView)
        view.addSubview(shadowView)

        scrollView.addSubview(contentView)
        contentView.addSubview(adView)
        contentView.addSubview(textView)
        contentView.fillInSuperview()

        let shadowViewHeight = navigationController?.navigationBar.frame.height ?? 0

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollViewBottomConstraint,

            shadowView.topAnchor.constraint(equalTo: view.topAnchor, constant: -shadowViewHeight),
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: shadowViewHeight),

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
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: view)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo, animations: { [weak self] in
            guard let self = self else { return }

            self.updateScrollViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self.view.layoutIfNeeded()
            self.shadowView.updateShadow(using: self.scrollView)
        })
    }

    private func updateScrollViewConstraint(withKeyboardVisible keyboardVisible: Bool, keyboardOffset: CGFloat) {
        let offset = keyboardOffset + view.windowSafeAreaInsets.bottom
        scrollViewBottomConstraint.constant = -offset
    }

    // MARK: - Actions

    @objc private func handleCancelButtonTap() {
        delegate?.favoriteAdCommentViewControllerDidSelectCancel(self)
    }

    @objc private func handleSaveButtonTap() {
        delegate?.favoriteAdCommentViewController(self, didSelectSaveWithText: "")
    }
}

// MARK: - RemoteImageViewDataSource

extension FavoriteAdCommentViewController: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return adImage
    }

    func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        completion(adImage)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - UIScrollViewDelegate

extension FavoriteAdCommentViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        shadowView.updateShadow(using: scrollView)
    }
}

// MARK: - TextViewDelegate

extension FavoriteAdCommentViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        saveButton.isEnabled = textView.text != adViewModel.comment
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
