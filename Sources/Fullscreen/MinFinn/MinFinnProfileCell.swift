//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol MinFinnProfileCellDelegate: AnyObject {
    func minFinnProfileCellDidSelectProfileImage(_ cell: MinFinnProfileCell)
    func minFinnProfileCell(_ cell: MinFinnProfileCell, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void)
}

class MinFinnProfileCell: UITableViewCell {

    weak var delegate: MinFinnProfileCellDelegate?

    private lazy var identityView: IdentityView = {
        let view = IdentityView(viewModel: nil)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        identityView.viewModel = nil
    }

    func configure(with model: MinFinnProfileCellModel?) {
        identityView.viewModel = model
    }
}

extension MinFinnProfileCell: IdentityViewDelegate {
    func identityViewWasTapped(_ identityView: IdentityView) {
        delegate?.minFinnProfileCellDidSelectProfileImage(self)
    }

    func identityView(_ identityView: IdentityView, loadImageWithUrl url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        delegate?.minFinnProfileCell(self, loadImageWithUrl: url, completionHandler: completionHandler)
    }
}

private extension MinFinnProfileCell {
    func setup() {
        backgroundColor = .clear

        contentView.addSubview(identityView)
        identityView.fillInSuperview(
            insets: UIEdgeInsets(top: 0, left: .mediumLargeSpacing, bottom: 0, right: -.mediumLargeSpacing)
        )
    }
}
