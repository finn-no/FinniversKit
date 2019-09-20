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

    public static func compactHeight(for viewModel: FavoriteFolderActionViewModel) -> CGFloat {
        return rowHeight * CGFloat(viewModel.kind.actions.subtracting([.shareLink]).count)
    }

    public static func expandedHeight(for viewModel: FavoriteFolderActionViewModel) -> CGFloat {
        return rowHeight * CGFloat(viewModel.kind.actions.count)
    }

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
        title: viewModel.renameText,
        icon: .pencilPaper
    )

    private lazy var deleteButton = makeButton(
        withAction: .delete,
        title: viewModel.deleteText,
        icon: .favoritesDelete,
        tintColor: .cherry
    )

    private lazy var shareView: FavoriteFolderShareToggleView = {
        let view = FavoriteFolderShareToggleView(withAutoLayout: true)
        view.configure(withTitle: viewModel.shareToggleText, switchOn: isShared)
        view.delegate = self
        return view
    }()

    private lazy var copyLinkView: FavoriteFolderShareLinkView = {
        let view = FavoriteFolderShareLinkView(withAutoLayout: true)
        view.configure(
            withButtonTitle: viewModel.shareLinkButtonTitle,
            description: viewModel.shareLinkButtonDescription
        )
        view.delegate = self
        return view
    }()

    private lazy var animatingConstraint: NSLayoutConstraint = {
        let constant = isShared ? rowHeight : 0

        switch self.viewModel.kind {
        case .full:
            return deleteButton.topAnchor.constraint(equalTo: shareView.bottomAnchor, constant: constant)
        case .minimal:
            return copyLinkView.topAnchor.constraint(equalTo: shareView.topAnchor, constant: constant)
        }
    }()

    private var rowHeight: CGFloat {
        return FavoriteFolderActionViewController.rowHeight
    }

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
        animatingConstraint.constant = min(
            animatingConstraint.constant + offsetY,
            rowHeight
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
        view.addSubview(copyLinkView)
        view.addSubview(shareView)

        var constraints = [
            editButton.topAnchor.constraint(equalTo: view.topAnchor),
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: rowHeight),

            shareView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shareView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shareView.heightAnchor.constraint(equalToConstant: rowHeight),

            copyLinkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            copyLinkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            copyLinkView.heightAnchor.constraint(equalToConstant: rowHeight)
        ]

        switch viewModel.kind {
        case .full:
            view.addSubview(changeNameButton)
            view.addSubview(deleteButton)

            constraints.append(contentsOf: [
                changeNameButton.topAnchor.constraint(equalTo: editButton.bottomAnchor),
                changeNameButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                changeNameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                changeNameButton.heightAnchor.constraint(equalToConstant: rowHeight),

                shareView.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor),
                copyLinkView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor),

                deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                deleteButton.heightAnchor.constraint(equalToConstant: rowHeight)
            ])
        case .minimal:
            constraints.append(contentsOf: [
                shareView.topAnchor.constraint(equalTo: editButton.bottomAnchor)
            ])
        }

        constraints.append(animatingConstraint)
        NSLayoutConstraint.activate(constraints)
    }

    private func updateSeparators() {
        editButton.isSeparatorHidden = false
        changeNameButton.isSeparatorHidden = false
        shareView.isSeparatorHidden = viewModel.kind == .minimal || isShared
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap(_ button: FavoriteFolderActionButton) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: button.action)
    }
}

// MARK: - FavoriteFolderShareToggleViewDelegate

extension FavoriteFolderActionViewController: FavoriteFolderShareToggleViewDelegate {
    func favoriteFolderShareToggleView(_ view: FavoriteFolderShareToggleView, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .toggleSharing)
    }
}

// MARK: - FavoriteFolderShareLinkViewDelegate

extension FavoriteFolderActionViewController: FavoriteFolderShareLinkViewDelegate {
    func favoriteFolderShareLinkViewDidSelectButton(_ view: FavoriteFolderShareLinkView) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .shareLink)
    }
}

// MARK: - Private extensions

private extension FavoriteFolderActionViewModel.Kind {
    var actions: Set<FavoriteFolderAction> {
        switch self {
        case .full:
            return Set(FavoriteFolderAction.allCases)
        case .minimal:
            return Set([.edit, .toggleSharing, .shareLink])
        }
    }
}
