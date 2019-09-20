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
    public static let compactHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withShareLink: false).count)
    public static let expandedHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withShareLink: true).count)

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionViewControllerDelegate?

    public var isShared: Bool {
        didSet {
            updateSeparators()
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteFolderActionViewModel

    private lazy var editButton = makeButton(withAction: .edit, title: viewModel.editText, icon: .favoritesEdit)

    private lazy var changeNameButton = makeButton(
        withAction: .rename,
        title: viewModel.changeNameText,
        icon: .pencilPaper
    )

    private lazy var deleteButton = makeButton(
        withAction: .delete,
        title: viewModel.deleteText,
        icon: .favoritesDelete,
        tintColor: .cherry
    )

    private lazy var shareView: FavoriteFolderShareView = {
        let view = FavoriteFolderShareView(withAutoLayout: true)
        view.configure(withTitle: viewModel.shareText, switchOn: isShared)
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

    private lazy var deleteButtonTopConstraint = deleteButton.topAnchor.constraint(
        equalTo: shareView.bottomAnchor,
        constant: isShared ? deleteButtonMaxTopConstant : 0
    )

    private var rowHeight: CGFloat {
        return FavoriteFolderActionViewController.rowHeight
    }

    private let deleteButtonMaxTopConstant = rowHeight

    // MARK: - Init

    public init(viewModel: FavoriteFolderActionViewModel, isShared: Bool = false) {
        self.viewModel = viewModel
        self.isShared = isShared
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

    func animate(with offsetY: CGFloat) {
        deleteButtonTopConstraint.constant = min(
            deleteButtonTopConstraint.constant + offsetY,
            deleteButtonMaxTopConstant
        )
    }

    // MARK: - Setup

    private func makeButton(
        withAction action: FavoriteFolderAction,
        title: String,
        icon: FinniversImageAsset,
        tintColor: UIColor = .licorice
    ) -> FavoriteFolderActionButton {
        let button = FavoriteFolderActionButton(action: action, title: title, icon: icon, tintColor: tintColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleActionButtonTap(_:)), for: .touchUpInside)
        return button
    }

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
        shareView.isSeparatorHidden = isShared
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap(_ button: FavoriteFolderActionButton) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: button.action)
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderShareViewDelegate {
    func favoriteFolderShareView(_ view: FavoriteFolderShareView, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .toggleSharing)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderCopyLinkViewDelegate {
    func favoriteFolderCopyLinkViewDidSelectButton(_ view: FavoriteFolderCopyLinkView) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .shareLink)
    }
}
