//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

protocol KlimabroletContentViewDelegate: AnyObject {
    func klimabroletViewDidSelectReadMore(_ view: KlimabroletContentView)
}

class KlimabroletContentView: UIView {
    weak var delegate: KlimabroletContentViewDelegate?

    private lazy var bannerImageView: UIView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .klimabroletBanner)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var subtitleTagView: EarthHourTagView = {
        let view = EarthHourTagView(withAutoLayout: true)
        view.stackView.alignment = .center
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        let font = UIFont.font(ofSize: 22, weight: .bold, textStyle: .title2)
        label.font = font
        label.textAlignment = .center
        label.textColor = .text
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
        backgroundColor = .background

        addSubview(bannerImageView)
        addSubview(titleLabel)
        addSubview(subtitleTagView)
        addSubview(bodyTextLabel)
        addSubview(accessoryButton)

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalTo: bannerImageView.widthAnchor, multiplier: 0.6),

            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),

            subtitleTagView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing50),
            subtitleTagView.centerXAnchor.constraint(equalTo: centerXAnchor),

            bodyTextLabel.topAnchor.constraint(equalTo: subtitleTagView.bottomAnchor, constant: Warp.Spacing.spacing200),
            bodyTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing400),
            bodyTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing400),

            accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: Warp.Spacing.spacing200),
            accessoryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            accessoryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
            accessoryButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Warp.Spacing.spacing400),
            accessoryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc private func handleTapOnAccessoryButton() {
        delegate?.klimabroletViewDidSelectReadMore(self)
    }
}
