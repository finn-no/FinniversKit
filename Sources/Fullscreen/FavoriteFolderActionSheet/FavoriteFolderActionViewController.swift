//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderActionViewControllerDelegate: AnyObject {
    func favoriteFolderActionViewController(
        _ viewController: FavoriteFolderActionViewController,
        didSelectAction action: FavoriteFolderAction
    )
}

public final class FavoriteFolderActionViewController: UIViewController {
    public static let rowHeight: CGFloat = 48.0
    public static let compactHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: false).count)
    public static let expandedHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: true).count)

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionViewControllerDelegate?

    public var isCopyLinkHidden: Bool {
        didSet {
           updateSeparators()
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteFolderActionViewModel

    private lazy var editButton = FavoriteFolderActionButton(title: viewModel.editText, icon: .favoritesEdit)
    private lazy var changeNameButton = FavoriteFolderActionButton(title: viewModel.changeNameText, icon: .pencilPaper)

    private lazy var deleteButton = FavoriteFolderActionButton(
        title: viewModel.deleteText,
        icon: .favoritesDelete,
        tintColor: .cherry
    )

    private lazy var shareView: FavoriteFolderShareView = {
        let view = FavoriteFolderShareView(withAutoLayout: true)
        view.configure(withTitle: viewModel.shareText, switchOn: !isCopyLinkHidden)
        view.delegate = self
        return view
    }()

    private lazy var copyLinkView: FavoriteFolderCopyLinkView = {
        let view = FavoriteFolderCopyLinkView(withAutoLayout: true)
        view.configure(
            withButtonTitle: viewModel.copyLinkButtonTitle,
            description: viewModel.copyLinkButtonDescription
        )
        view.delegate = self
        return view
    }()

    private lazy var deleteButtonTopConstraint: NSLayoutConstraint = {
        let constant = isCopyLinkHidden ? 0 : rowHeight
        return deleteButton.topAnchor.constraint(equalTo: shareView.bottomAnchor, constant: constant)
    }()

    private var rowHeight: CGFloat {
        return FavoriteFolderActionViewController.rowHeight
    }

    // MARK: - Init

    public init(viewModel: FavoriteFolderActionViewModel, isCopyLinkHidden: Bool = true) {
        self.viewModel = viewModel
        self.isCopyLinkHidden = isCopyLinkHidden
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateSeparators()
    }

    // MARK: - Animation

    func animateRows(with offsetY: CGFloat) {
        deleteButtonTopConstraint.constant += offsetY
    }

    // MARK: - Setup

    private func setup() {
        view.addSubview(editButton)
        view.addSubview(changeNameButton)
        view.addSubview(copyLinkView)
        view.addSubview(shareView)
        view.addSubview(deleteButton)

        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.topAnchor),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: rowHeight),

            changeNameButton.topAnchor.constraint(equalTo: editButton.bottomAnchor),
            changeNameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            changeNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            changeNameButton.heightAnchor.constraint(equalToConstant: rowHeight),

            shareView.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor),
            shareView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shareView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shareView.heightAnchor.constraint(equalToConstant: rowHeight),

            copyLinkView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor),
            copyLinkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            copyLinkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            copyLinkView.heightAnchor.constraint(equalToConstant: rowHeight),

            deleteButtonTopConstraint,
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
    }

    private func updateSeparators() {
        editButton.isSeparatorHidden = false
        changeNameButton.isSeparatorHidden = false
        shareView.isSeparatorHidden = !isCopyLinkHidden
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderShareViewDelegate {
    func favoriteFolderShareView(_ view: FavoriteFolderShareView, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .share)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderCopyLinkViewDelegate {
    func favoriteFolderCopyLinkViewDidSelectButton(_ view: FavoriteFolderCopyLinkView) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .copyLink)
    }
}
