//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public class FavoriteAdsListEmptyView: UIView {

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textAlignment = .center
        label.textColor = .text
        label.font = .title3
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textAlignment = .center
        label.textColor = .text
        label.font = .bodyStrong
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background

        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)

        stackView.setCustomSpacing(Warp.Spacing.spacing200, after: iconImageView)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing800 * 2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),
        ])
    }

    // MARK: - Public methods

    public func configure(withImage image: UIImage, title: String, body: String) {
        iconImageView.image = image
        titleLabel.text = title
        bodyLabel.text = body
    }
}
