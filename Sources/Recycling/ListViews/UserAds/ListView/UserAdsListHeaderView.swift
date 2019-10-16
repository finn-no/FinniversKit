//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol UserAdsListHeaderViewDelegate: AnyObject {
    func userAdsListHeaderView(_ userAdsListHeaderView: UserAdsListHeaderView, didTapSeeMoreButton button: Button)
}

public class UserAdsListHeaderView: UIView {

    // MARK: - Public properties

    public weak var delegate: UserAdsListHeaderViewDelegate?
    public let section: Int

    // MARK: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .detailStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textSecondary
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var moreButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .btnPrimary
        button.setTitleColor(.btnPrimary, for: .normal)
        button.titleLabel?.font = .detailStrong
        button.backgroundColor = .clear
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        backgroundColor = .bgTertiary

        addSubview(titleLabel)
        addSubview(moreButton)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: centerXAnchor),

            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            moreButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @objc private func seeMoreButtonTapped(_ sender: Button) {
        delegate?.userAdsListHeaderView(self, didTapSeeMoreButton: sender)
    }

    // MARK: - Dependency injection

    public var model: UserAdsListHeaderViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title.uppercased()
            moreButton.setTitle(model.buttonTitle, for: .normal)
        }
    }
}
