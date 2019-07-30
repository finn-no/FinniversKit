//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

protocol KlimabroletContentViewDelegate: AnyObject {
    func klimabroletViewDidSelectReadMore(_ view: KlimabroletContentView)
}

class KlimabroletContentView: UIView {
    weak var delegate: KlimabroletContentViewDelegate?

    private lazy var bannerImageView: UIView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .klimaboletBanner)
        return imageView
    }()

    private lazy var subtitleTagView = EarthHourTagView(withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        let font = UIFont(name: FontType.bold.rawValue, size: 22)?
            .scaledFont(forTextStyle: .title2)
        label.font = font
        label.textAlignment = .center
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyTextLabel: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var accessoryButton: UIButton = {
        let button = Button(style: .link, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(handleTapOnAccessoryButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal methods

    func configure(with viewModel: KlimabroletViewModel) {
        titleLabel.text = viewModel.title
        subtitleTagView.titleLabel.text = viewModel.subtitle
        bodyTextLabel.text = viewModel.bodyText
        accessoryButton.setTitle(viewModel.readMoreButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .milk

        addSubview(bannerImageView)
        addSubview(titleLabel)
        addSubview(subtitleTagView)
        addSubview(bodyTextLabel)
        addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            subtitleTagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .smallSpacing),
            subtitleTagView.centerXAnchor.constraint(equalTo: centerXAnchor),

            bodyTextLabel.topAnchor.constraint(equalTo: subtitleTagView.bottomAnchor, constant: .mediumLargeSpacing),
            bodyTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            bodyTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: .mediumLargeSpacing),
            accessoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            accessoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            accessoryButton.heightAnchor.constraint(greaterThanOrEqualToConstant: .largeSpacing),
            accessoryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc private func handleTapOnAccessoryButton() {
        delegate?.klimabroletViewDidSelectReadMore(self)
    }
}
