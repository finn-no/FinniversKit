//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

class MessageFormToolbar: UIView {

    // MARK: - UI properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MessageFormTemplateCell.self)
        view.register(MessageFormCustomizeCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, leading: .mediumLargeSpacing, bottom: 0, trailing: .smallSpacing)
        return view
    }()

    // MARK: - Private properties

    private let viewModel: MessageFormViewModel

    private let toolbarHeight: CGFloat = 60
    private let toolbarTopPadding: CGFloat = .smallSpacing
    private var toolbarCellHeight: CGFloat { return toolbarHeight - toolbarTopPadding }
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
        backgroundColor = UIColor(r: 208, g: 212, b: 215)

        addSubview(collectionView)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: toolbarTopPadding, leading: 0, bottom: 0, trailing: 0))

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: toolbarHeight)
        ])
    }
}

extension MessageFormToolbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return MessageFormCustomizeCell.size
        case 1:
            let text = viewModel.messageTemplates[safe: indexPath.row] ?? ""
            let idealWidth = text.multiLineWidth(withConstrainedHeight: toolbarCellHeight, font: .detail, minimumWidth: 70)
            let width = CGFloat.minimum(idealWidth + 2 * CGFloat.smallSpacing, toolbarCellMaxWidth)
            return CGSize(width: width, height: toolbarCellHeight)
        default:
            fatalError("Unexpected section: \(indexPath.section)")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: .mediumLargeSpacing)
        }

        return UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

extension MessageFormToolbar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel.messageTemplates.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeue(MessageFormCustomizeCell.self, for: indexPath)
        case 1:
            let cell = collectionView.dequeue(MessageFormTemplateCell.self, for: indexPath)
            cell.configure(withText: viewModel.messageTemplates[safe: indexPath.row] ?? "")
            return cell
        default:
            fatalError("Unexpected section: \(indexPath.section)")
        }
    }
}

// MARK: - MessageFormToolbarCell

private class MessageFormTemplateCell: UICollectionViewCell {

    // MARK: - UI properties

    private lazy var label: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()

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
        contentView.layer.cornerRadius = 4
        contentView.backgroundColor = .toothPaste

        contentView.addSubview(label)
        label.fillInSuperview(margin: .smallSpacing)
    }

    // MARK: - Internal methods

    func configure(withText text: String) {
        label.text = text
    }
}

// MARK: - MessageFormCustomizeCell

private class MessageFormCustomizeCell: UICollectionViewCell {

    static let size = CGSize(width: 25, height: 25)

    // MARK: - UI properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: .init(named: .plus))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

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
        contentView.layer.cornerRadius = MessageFormCustomizeCell.size.width / 2
        contentView.backgroundColor = .toothPaste

        contentView.addSubview(imageView)
        imageView.fillInSuperview()
    }
}
