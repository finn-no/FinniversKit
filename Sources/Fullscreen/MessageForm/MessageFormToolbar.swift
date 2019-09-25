//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol MessageFormToolbarDelegate: AnyObject {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: MessageFormTemplate)
}

class MessageFormToolbar: UIView {

    // MARK: - UI properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MessageFormTemplateCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var safeAreaHeight: CGFloat = {
        return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }()

    private lazy var safeAreaCoverView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = MessageFormToolbar.backgroundColor
        return view
    }()

    // MARK: - Internal properties

    weak var delegate: MessageFormToolbarDelegate?

    // MARK: - Private properties

    private static let backgroundColor = UIColor(r: 208, g: 212, b: 215)

    private let viewModel: MessageFormViewModel

    private let toolbarHeight: CGFloat = 68
    private let toolbarTopPadding: CGFloat = .mediumSpacing
    private let toolbarBottomPadding: CGFloat = .mediumSpacing
    private var toolbarCellHeight: CGFloat { return toolbarHeight - toolbarTopPadding - toolbarBottomPadding }
    private var toolbarCellMaxWidth: CGFloat {
        if UIDevice.isIPad() {
            return 200
        } else {
            return 130
        }
    }

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        backgroundColor = MessageFormToolbar.backgroundColor

        addSubview(collectionView)
        addSubview(safeAreaCoverView)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: toolbarTopPadding, leading: 0, bottom: -toolbarBottomPadding, trailing: 0))

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: toolbarHeight),

            safeAreaCoverView.heightAnchor.constraint(equalToConstant: safeAreaHeight),
            safeAreaCoverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCoverView.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaCoverView.topAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func offsetForToolbar(withKeyboardVisible keyboardVisible: Bool) -> CGFloat {
        /// The Toolbar view wants to hide its' bottom padding when the keyboard is visible,
        /// as this padding is "embedded" in the top of the stock keyboard itself.
        if keyboardVisible {
            return safeAreaHeight - toolbarBottomPadding
        } else {
            return safeAreaHeight
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }
}

extension MessageFormToolbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, leading: .mediumSpacing, bottom: 0, trailing: .mediumSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MessageFormToolbar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messageTemplates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let template = viewModel.messageTemplates[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        let cell = collectionView.dequeue(MessageFormTemplateCell.self, for: indexPath)
        cell.configure(withTemplate: template, maxWidth: toolbarCellMaxWidth, maxHeight: toolbarCellHeight)
        cell.delegate = self
        return cell
    }
}

extension MessageFormToolbar: MessageFormTemplateCellDelegate {
    fileprivate func messageFormTemplateCellWasTapped(_ cell: MessageFormTemplateCell) {
        guard let messageTemplate = cell.template else {
            return
        }

        delegate?.messageFormToolbar(self, didSelectMessageTemplate: messageTemplate)
    }
}

// MARK: - MessageFormTemplateCell

private protocol MessageFormTemplateCellDelegate: AnyObject {
    func messageFormTemplateCellWasTapped(_ cell: MessageFormTemplateCell)
}

private class MessageFormTemplateCell: UICollectionViewCell {

    // MARK: - UI properties

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundColor(color: .toothPaste, forState: .normal)
        button.setBackgroundColor(color: .secondaryBlue, forState: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var label: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private var maxWidth: CGFloat = 0
    private var maxHeight: CGFloat = 0

    // MARK: - Internal properties

    weak var delegate: MessageFormTemplateCellDelegate?
    private(set) var template: MessageFormTemplate?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentView.addSubview(button)
        button.fillInSuperview()

        button.addSubview(label)
        label.fillInSuperview(margin: .smallSpacing)
    }

    // MARK: - Overrides

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        var frame = layoutAttributes.frame
        frame.size.width = maxWidth
        frame.size.height = maxHeight
        layoutAttributes.frame = frame
        return layoutAttributes
    }

    // MARK: - Internal methods

    func configure(withTemplate template: MessageFormTemplate, maxWidth: CGFloat, maxHeight: CGFloat) {
        self.template = template
        label.text = template.text.condenseWhitespace()
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    // MARK: - Private methods

    @objc private func buttonTapped() {
        delegate?.messageFormTemplateCellWasTapped(self)
    }
}

// MARK: - Private extensions

private extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }

        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

private extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

