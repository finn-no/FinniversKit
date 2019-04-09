//
//  Copyright © FINN.no AS. All rights reserved.
//

import UIKit

public class StatisticsItemEmptyView: UIView {

    // MARK: - Private

    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: .statsEmpty))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = .ice
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 0
        label.font = UIFont.bodyStrong
        label.textColor = .licorice
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 0
        label.font = UIFont.caption
        label.textColor = .licorice
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    // MARK: - Initalization

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(frame:)")
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }

    // MARK: - Dependency injection

    public var model: StatisticsItemEmptyViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            descriptionLabel.text = model.description
            accessibilityLabel = model.accessibilityLabel
        }
    }
}
