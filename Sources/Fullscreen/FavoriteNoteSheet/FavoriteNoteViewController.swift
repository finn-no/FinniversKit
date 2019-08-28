//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FavoriteNoteViewControllerDelegate: AnyObject {
    func favoriteNoteViewControllerDidSelectCancel(_ viewController: FavoriteNoteViewController)
    func favoriteNoteViewController(_ viewController: FavoriteNoteViewController, didSelectSaveWithText text: String?)
}

final class FavoriteNoteViewController: UIViewController {
    weak var delegate: FavoriteNoteViewControllerDelegate?

    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private let noteViewModel: FavoriteNoteViewModel
    private let adViewModel: FavoriteAdViewModel
    private let notificationCenter: NotificationCenter

    private lazy var cancelButton = UIBarButtonItem(
        title: noteViewModel.cancelButtonText,
        style: .plain,
        target: self,
        action: #selector(handleCancelButtonTap)
    )

    private lazy var saveButton = UIBarButtonItem(
        title: noteViewModel.saveButtonText,
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
        view.configure(with: adViewModel)
        view.remoteImageViewDataSource = remoteImageViewDataSource
        return view
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.text = noteViewModel.note
        textView.placeholderText = noteViewModel.notePlaceholder
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()

    private lazy var scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

    // MARK: - Init

    init(
        noteViewModel: FavoriteNoteViewModel,
        adViewModel: FavoriteAdViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        notificationCenter: NotificationCenter = .default
    ) {
        self.remoteImageViewDataSource = remoteImageViewDataSource
        self.noteViewModel = noteViewModel
        self.adViewModel = adViewModel
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

        title = noteViewModel.title
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
            self?.updateScrollViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self?.view.layoutIfNeeded()
        })
    }

    private func updateScrollViewConstraint(withKeyboardVisible keyboardVisible: Bool, keyboardOffset: CGFloat) {
        let offset = keyboardOffset + view.windowSafeAreaInsets.bottom
        scrollViewBottomConstraint.constant = -offset
    }

    // MARK: - Actions

    @objc private func handleCancelButtonTap() {
        delegate?.favoriteNoteViewControllerDidSelectCancel(self)
    }

    @objc private func handleSaveButtonTap() {
        delegate?.favoriteNoteViewController(self, didSelectSaveWithText: "")
    }
}

// MARK: - UIScrollViewDelegate

extension FavoriteNoteViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        shadowView.updateShadow(using: scrollView)
    }
}

// MARK: - TextViewDelegate

extension FavoriteNoteViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
        saveButton.isEnabled = textView.text != noteViewModel.note
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
