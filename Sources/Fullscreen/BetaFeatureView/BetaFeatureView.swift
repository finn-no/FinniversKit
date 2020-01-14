//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public struct BetaFeatureViewModel {
    public let iconImage: UIImage?
    public let title: String
    public let description: String
    public let firstButtonTitle: String
    public let secondButtonTitle: String

    public init(
        iconImage: UIImage?,
        title: String,
        description: String,
        firstButtonTitle: String,
        secondButtonTitle: String
    ) {
        self.iconImage = iconImage
        self.title = title
        self.description = description
        self.firstButtonTitle = firstButtonTitle
        self.secondButtonTitle = secondButtonTitle
    }
}

public protocol BetaFeatureViewDelegate: AnyObject {
    func betaFeatureViewDidSelectFirstButton(_ view: BetaFeatureView)
    func betaFeatureViewDidSelectSecondButton(_ view: BetaFeatureView)
}

public class BetaFeatureView: UIView {
    // MARK: - Public properties
    public weak var delegate: BetaFeatureViewDelegate?

    // MARK: - Private properties
    private lazy var betaFlagView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .betaPill)
        return imageView
    }()

    private lazy var iconImageView = UIImageView(withAutoLayout: true)
    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var firstButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleTapOnFirstButton), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()

    private lazy var secondButton: Button = {
        let button = Button(style: .flat, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleTapOnSecondButton), for: .touchUpInside)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods
    public func configure(with viewModel: BetaFeatureViewModel) {
        iconImageView.image = viewModel.iconImage
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.description
        firstButton.setTitle(viewModel.firstButtonTitle, for: .normal)
        secondButton.setTitle(viewModel.secondButtonTitle, for: .normal)
    }

    // MARK: - Private methods
    private func setup() {
        let betaPillSize = CGSize(width: 52, height: 24)

        iconImageView.addSubview(betaFlagView)

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(firstButton)
        addSubview(secondButton)

        layoutMargins = UIEdgeInsets(all: 0)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: .veryLargeSpacing),
            iconImageView.heightAnchor.constraint(equalToConstant: .veryLargeSpacing),
            iconImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: .largeSpacing),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            betaFlagView.widthAnchor.constraint(equalToConstant: betaPillSize.width),
            betaFlagView.heightAnchor.constraint(equalToConstant: betaPillSize.height),
            betaFlagView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            betaFlagView.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),

            firstButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .largeSpacing),
            firstButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            firstButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            secondButton.topAnchor.constraint(equalTo: firstButton.bottomAnchor, constant: .mediumSpacing),
            secondButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            secondButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            secondButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])

        betaFlagView.transform = CGAffineTransform
            .init(translationX: .largeSpacing - .smallSpacing, y: -.largeSpacing + .smallSpacing)
            .rotated(by: .pi / 4.5)
    }

    @objc func handleTapOnFirstButton() {
        delegate?.betaFeatureViewDidSelectFirstButton(self)
    }

    @objc func handleTapOnSecondButton() {
        delegate?.betaFeatureViewDidSelectSecondButton(self)
    }
}
