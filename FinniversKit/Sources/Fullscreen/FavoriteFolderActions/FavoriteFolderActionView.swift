//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderActionViewDelegate: AnyObject {
    func favoriteFolderActionView(
        _ view: FavoriteFolderActionView,
        didSelectAction action: FavoriteFolderAction
    )
}

public final class FavoriteFolderActionView: UIView {
    public static let rowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionViewDelegate?

    public var isShared: Bool {
        didSet {
            updateSeparators()
            shareLinkView.isHidden = !isShared
        }
    }

    public var height: CGFloat {
        return isShared
            ? rowHeight * CGFloat(viewModel.appearance.actions.count)
            : rowHeight * CGFloat(viewModel.appearance.actions.subtracting([.shareLink]).count)
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
        tintColor: .btnCritical
    )

    private lazy var shareToggleView: FavoriteFolderShareToggleView = {
        let view = FavoriteFolderShareToggleView(withAutoLayout: true)
        view.configure(withTitle: viewModel.shareToggleText, switchOn: isShared)
        view.delegate = self
        return view
    }()

    private lazy var shareLinkView: FavoriteFolderShareLinkView = {
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

        switch self.viewModel.appearance {
        case .regular, .xmasFolder:
            return deleteButton.topAnchor.constraint(equalTo: shareToggleView.bottomAnchor, constant: constant)
        case .defaultFolder:
            return shareLinkView.topAnchor.constraint(equalTo: shareToggleView.topAnchor, constant: constant)
        }
    }()

    private var rowHeight: CGFloat {
        return FavoriteFolderActionView.rowHeight
    }

    // MARK: - Init

    public init(viewModel: FavoriteFolderActionViewModel, isShared: Bool = false) {
        self.viewModel = viewModel
        self.isShared = isShared
        super.init(frame: .zero)
        setup()
        updateSeparators()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    public func setAction(_ action: FavoriteFolderAction, enabled: Bool) {
        switch action {
        case .edit:
            editButton.isEnabled = enabled
        case .rename:
            changeNameButton.isEnabled = enabled
        case .toggleSharing:
            shareToggleView.isEnabled = enabled
        case .shareLink:
            shareLinkView.isEnabled = enabled
        case .delete:
            deleteButton.isEnabled = enabled
        }
    }

    // MARK: - Animation

    public func animate(with offsetY: CGFloat) {
        animatingConstraint.constant = min(
            animatingConstraint.constant + offsetY,
            rowHeight
        )
    }

    public func expand() {
        animatingConstraint.constant = FavoriteFolderActionView.rowHeight
    }

    public func collapse() {
        animatingConstraint.constant = 0
    }

    // MARK: - Setup

    private func makeButton(
        withAction action: FavoriteFolderAction,
        title: String,
        icon: ImageAsset,
        tintColor: UIColor = .textPrimary
    ) -> FavoriteFolderActionButton {
        let button = FavoriteFolderActionButton(action: action, title: title, icon: icon, tintColor: tintColor)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleActionButtonTap(_:)), for: .touchUpInside)
        return button
    }

    private func setup() {
        addSubview(editButton)
        addSubview(shareLinkView)
        addSubview(shareToggleView)

        var constraints = [
            editButton.topAnchor.constraint(equalTo: topAnchor),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.heightAnchor.constraint(equalToConstant: rowHeight),

            shareToggleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareToggleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareToggleView.heightAnchor.constraint(equalToConstant: rowHeight),

            shareLinkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLinkView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLinkView.heightAnchor.constraint(equalToConstant: rowHeight)
        ]

        let deleteButtonConstraints = [
            deleteButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: rowHeight)
        ]

        switch viewModel.appearance {
        case .regular:
            addSubview(changeNameButton)
            addSubview(deleteButton)

            constraints.append(contentsOf: [
                changeNameButton.topAnchor.constraint(equalTo: editButton.bottomAnchor),
                changeNameButton.leadingAnchor.constraint(equalTo: leadingAnchor),
                changeNameButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                changeNameButton.heightAnchor.constraint(equalToConstant: rowHeight),

                shareToggleView.topAnchor.constraint(equalTo: changeNameButton.bottomAnchor),
                shareLinkView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor)
            ] + deleteButtonConstraints)
        case .defaultFolder:
            constraints.append(contentsOf: [
                shareToggleView.topAnchor.constraint(equalTo: editButton.bottomAnchor)
            ])
        case .xmasFolder:
            addSubview(deleteButton)

            constraints.append(contentsOf: [
                shareToggleView.topAnchor.constraint(equalTo: editButton.bottomAnchor),
                shareLinkView.bottomAnchor.constraint(equalTo: deleteButton.topAnchor)
            ] + deleteButtonConstraints)
        }

        constraints.append(animatingConstraint)
        NSLayoutConstraint.activate(constraints)
    }

    private func updateSeparators() {
        editButton.isSeparatorHidden = false
        changeNameButton.isSeparatorHidden = false
        shareToggleView.isSeparatorHidden = viewModel.appearance == .defaultFolder || isShared
    }

    // MARK: - Actions

    @objc private func handleActionButtonTap(_ button: FavoriteFolderActionButton) {
        delegate?.favoriteFolderActionView(self, didSelectAction: button.action)
    }
}

// MARK: - FavoriteFolderShareToggleViewDelegate

extension FavoriteFolderActionView: FavoriteFolderShareToggleViewDelegate {
    func favoriteFolderShareToggleView(_ view: FavoriteFolderShareToggleView, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionView(self, didSelectAction: .toggleSharing)
    }
}

// MARK: - FavoriteFolderShareLinkViewDelegate

extension FavoriteFolderActionView: FavoriteFolderShareLinkViewDelegate {
    func favoriteFolderShareLinkViewDidSelectButton(_ view: FavoriteFolderShareLinkView) {
        delegate?.favoriteFolderActionView(self, didSelectAction: .shareLink)
    }
}

// MARK: - Private extensions

private extension FavoriteFolderActionViewModel.Appearance {
    var actions: Set<FavoriteFolderAction> {
        switch self {
        case .regular:
            return Set(FavoriteFolderAction.allCases)
        case .defaultFolder:
            return Set([.edit, .toggleSharing, .shareLink])
        case .xmasFolder:
            return Set([.edit, .toggleSharing, .shareLink, .delete])
        }
    }
}
