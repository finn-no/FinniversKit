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
    private let noteViewModel: FavoriteNoteViewModel
    private let adViewModel: FavoriteAdViewModel

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

    // MARK: - Init

    init(noteViewModel: FavoriteNoteViewModel, adViewModel: FavoriteAdViewModel) {
        self.noteViewModel = noteViewModel
        self.adViewModel = adViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton

        saveButton.isEnabled = false
        setup()
    }

    // MARK: - Setup

    private func setup() {

    }

    // MARK: - Actions

    @objc private func handleCancelButtonTap() {
        delegate?.favoriteNoteViewControllerDidSelectCancel(self)
    }

    @objc private func handleSaveButtonTap() {
        delegate?.favoriteNoteViewController(self, didSelectSaveWithText: "")
    }
}
