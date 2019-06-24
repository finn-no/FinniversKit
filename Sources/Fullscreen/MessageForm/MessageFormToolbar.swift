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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, leading: .smallSpacing, bottom: 0, trailing: .smallSpacing)
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
        collectionView.register(MessageFormToolbarCell.self)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: toolbarTopPadding, leading: 0, bottom: 0, trailing: 0))

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: toolbarHeight)
        ])
    }
}

extension MessageFormToolbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = viewModel.messageTemplates[safe: indexPath.row] ?? ""
        let idealWidth = text.multiLineWidth(withConstrainedHeight: toolbarCellHeight, font: .detail, minimumWidth: 70)
        let width = CGFloat.minimum(idealWidth + 2 * CGFloat.smallSpacing, toolbarCellMaxWidth)
        return CGSize(width: width, height: toolbarCellHeight)
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
        let cell = collectionView.dequeue(MessageFormToolbarCell.self, for: indexPath)
        cell.configure(withText: viewModel.messageTemplates[safe: indexPath.row] ?? "")
        return cell
    }
}

// MARK: - MessageFormToolbarCell

private class MessageFormToolbarCell: UICollectionViewCell {

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
        layer.cornerRadius = 4
        backgroundColor = .toothPaste

        addSubview(label)
        label.fillInSuperview(margin: .smallSpacing)
    }

    // MARK: - Internal methods

    func configure(withText text: String) {
        label.text = text
    }
}
