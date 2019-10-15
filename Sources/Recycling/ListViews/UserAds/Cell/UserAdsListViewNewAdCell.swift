//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListViewNewAdCellDelegate: AnyObject {
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

    // MARK: - Private functions

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        selectionStyle = .none

        addSubview(createNewAdButton)

        NSLayoutConstraint.activate([
            createNewAdButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
            createNewAdButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            createNewAdButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            createNewAdButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

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

    // MARK: - Public functions

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let verticalInset = CGFloat(24)
        let horizontalInset = CGFloat(24)
        let largerTouchArea = CGRect(x: bounds.origin.x - horizontalInset, y: bounds.origin.y - verticalInset,
                                     width: bounds.size.width + (horizontalInset * 2), height: bounds.size.height + (verticalInset * 2))
        return largerTouchArea.contains(point)
    }
}
