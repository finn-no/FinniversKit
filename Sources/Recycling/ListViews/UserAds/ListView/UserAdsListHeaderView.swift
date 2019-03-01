//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListHeaderViewDelegate: class {
    func userAdsListHeaderView(_ userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button)
}

public class UserAdsListHeaderView: UIView {

    // MARK: - Public properties

    public weak var delegate: UserAdsListHeaderViewDelegate?
    public var section: Int

    // MARK: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title5)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .primaryBlue
        button.setTitleColor(.primaryBlue, for: .normal)
        button.titleLabel?.font = .title5
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(seeMoreButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Setup

    init(atSection: Int) {
        self.section = atSection
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .sardine

        addSubview(titleLabel)
        addSubview(moreButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func seeMoreButtonTapped(_ sender: Button) {
        delegate?.userAdsListHeaderView(self, didTapSeeMoreButton: sender)
    }

    // MARK: - Dependency injection

    public var model: UserAdsListHeaderViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            moreButton.setTitle(model.buttonTitle, for: .normal)
        }
    }
}
