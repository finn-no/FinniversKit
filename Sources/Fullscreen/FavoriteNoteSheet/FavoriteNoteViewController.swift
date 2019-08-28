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

    private lazy var adView: FavoriteAdView = {
        let view = FavoriteAdView(withAutoLayout: true)
        view.isMoreButtonHidden = true
        view.configure(with: adViewModel)
        view.remoteImageViewDataSource = remoteImageViewDataSource
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return view
    }()

    private lazy var textView: TextView = {
        let textView = TextView(withAutoLayout: true)
        textView.placeholderText = noteViewModel.notePlaceholder
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return textView
    }()

    private lazy var textViewBottomConstraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

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

    // MARK: - Setup

    private func setup() {
        view.addSubview(adView)
        view.addSubview(textView)

        let textViewHeight = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 86)
        textViewHeight.priority = .defaultHigh

        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumSpacing),
            adView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            textView.topAnchor.constraint(equalTo: adView.bottomAnchor, constant: .mediumSpacing),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing),
            textViewHeight,
            textViewBottomConstraint
        ])

        updateTextViewConstraint(withKeyboardVisible: false, keyboardOffset: 0)
    }

    // MARK: - Keyboard

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        guard let keyboardInfo = KeyboardNotificationInfo(notification) else { return }

        let keyboardVisible = keyboardInfo.action == .willShow
        let keyboardIntersection = keyboardInfo.keyboardFrameEndIntersectHeight(inView: view)

        UIView.animateAlongsideKeyboard(keyboardInfo: keyboardInfo) { [weak self] in
            self?.updateTextViewConstraint(withKeyboardVisible: keyboardVisible, keyboardOffset: keyboardIntersection)
            self?.view.layoutIfNeeded()
        }
    }

    private func updateTextViewConstraint(withKeyboardVisible keyboardVisible: Bool, keyboardOffset: CGFloat) {
        let offset = keyboardOffset + view.windowSafeAreaInsets.bottom + .mediumLargeSpacing
        textViewBottomConstraint.constant = -offset
    }

    // MARK: - Actions

    @objc private func handleCancelButtonTap() {
        delegate?.favoriteNoteViewControllerDidSelectCancel(self)
    }

    @objc private func handleSaveButtonTap() {
        delegate?.favoriteNoteViewController(self, didSelectSaveWithText: "")
    }
}

// MARK: - TextViewDelegate

extension FavoriteNoteViewController: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {

    }
}
