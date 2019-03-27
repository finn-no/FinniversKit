//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewNewAdCellDelegate: class {
    func userAdsListViewNewAdCell(_ userAdsListViewNewAdCell: UserAdsListViewNewAdCell, didTapCreateNewAdButton button: Button)
}

public class UserAdsListViewNewAdCell: UITableViewCell {
    // MARK: - Public properties

    public weak var delegate: UserAdsListViewNewAdCellDelegate?

    // MARK: - Internal properties

    private lazy var createNewAdButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createNewAdButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .milk
        selectionStyle = .none

        addSubview(createNewAdButton)

        NSLayoutConstraint.activate([
            createNewAdButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            createNewAdButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            createNewAdButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            createNewAdButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Private functions

    @objc private func createNewAdButtonTapped(_ sender: Button) {
        delegate?.userAdsListViewNewAdCell(self, didTapCreateNewAdButton: sender)
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            createNewAdButton.setTitle(model.title, for: .normal)
            accessibilityLabel = model.accessibilityLabel
        }
    }
}
