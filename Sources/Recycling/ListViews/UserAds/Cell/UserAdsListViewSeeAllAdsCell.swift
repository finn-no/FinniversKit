//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewSeeAllAdsCellDelegate: AnyObject {
    func userAdsListViewSeeAllAdsCell(_ userAdsListViewSeeAllAdsCell: UserAdsListViewSeeAllAdsCell, didTapSeeAllAdsButton button: Button)
}

public class UserAdsListViewSeeAllAdsCell: UITableViewCell {
    // MARK: - Public properties

    public weak var delegate: UserAdsListViewSeeAllAdsCellDelegate?

    // MARK: - Internal properties

    private lazy var seeAllAdsButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(seeAllAdsButtonTapped(_:)), for: .touchUpInside)
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
        separatorInset = UIEdgeInsets(top: 0, left: frame.width, bottom: 0, right: 0)

        addSubview(seeAllAdsButton)
        seeAllAdsButton.fillInSuperview()
    }

    // MARK: - Private functions

    @objc private func seeAllAdsButtonTapped(_ sender: Button) {
        delegate?.userAdsListViewSeeAllAdsCell(self, didTapSeeAllAdsButton: sender)
    }

    // MARK: - Dependency injection

    public var model: UserAdsListViewModel? {
        didSet {
            guard let model = model else { return }
            seeAllAdsButton.setTitle(model.title, for: .normal)
            accessibilityLabel = model.accessibilityLabel
        }
    }
}
