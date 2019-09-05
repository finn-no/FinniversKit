//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class AdsGridPromotedViewCell: AdsGridViewCell {
    override public func setup() {
        isAccessibilityElement = true

        backgroundColor = .milk
        imageView.contentMode = .scaleAspectFill
        subtitleLabel.textColor = .milk
        titleLabel.textColor = .milk
        titleLabel.numberOfLines = 2
        accessoryLabel.textColor = .milk
        imageDescriptionView.backgroundColor = .clear
        addSubview(imageBackgroundView)
        imageBackgroundView.addSubview(imageView)
        imageView.fillInSuperview()
        imageBackgroundView.fillInSuperview()

        let topGradient = CAGradientLayer()
        topGradient.frame = bounds
        topGradient.colors = [
            UIColor.black.withAlphaComponent(0.65).cgColor,
            UIColor.clear.cgColor
        ]
        topGradient.locations = [0, 0.3]
        let topGradientImageView = UIImageView(withAutoLayout: true)
        topGradientImageView.image = topGradient.toImage()
        imageBackgroundView.addSubview(topGradientImageView)

        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = bounds
        bottomGradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.65).cgColor
        ]
        bottomGradient.locations = [0.8, 1]
        let bottomGradientImageView = UIImageView(withAutoLayout: true)
        bottomGradientImageView.image = bottomGradient.toImage()
        imageBackgroundView.addSubview(bottomGradientImageView)

        addSubview(subtitleLabel)
        addSubview(titleLabel)
        addSubview(imageDescriptionView)
        addSubview(favoriteButton)

        imageDescriptionView.addSubview(iconImageView)
        imageDescriptionView.addSubview(imageTextLabel)
        imageDescriptionView.addSubview(accessoryLabel)

        NSLayoutConstraint.activate([
            topGradientImageView.topAnchor.constraint(equalTo: imageBackgroundView.topAnchor),
            topGradientImageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor),
            topGradientImageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor),

            bottomGradientImageView.bottomAnchor.constraint(equalTo: imageBackgroundView.bottomAnchor),
            bottomGradientImageView.leadingAnchor.constraint(equalTo: imageBackgroundView.leadingAnchor),
            bottomGradientImageView.trailingAnchor.constraint(equalTo: imageBackgroundView.trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: AdsGridViewCell.subtitleTopMargin),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            subtitleLabel.heightAnchor.constraint(equalToConstant: AdsGridViewCell.subtitleHeight),

            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: AdsGridViewCell.titleTopMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),

            iconImageView.leadingAnchor.constraint(equalTo: imageDescriptionView.leadingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: AdsGridViewCell.iconSize),
            iconImageView.widthAnchor.constraint(equalToConstant: AdsGridViewCell.iconSize),
            iconImageView.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            imageTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .mediumSpacing),
            imageTextLabel.trailingAnchor.constraint(equalTo: imageDescriptionView.trailingAnchor),
            imageTextLabel.centerYAnchor.constraint(equalTo: imageDescriptionView.centerYAnchor),

            accessoryLabel.topAnchor.constraint(equalTo: imageTextLabel.bottomAnchor, constant: .mediumSpacing),
            accessoryLabel.leadingAnchor.constraint(equalTo: imageDescriptionView.leadingAnchor),
            accessoryLabel.trailingAnchor.constraint(equalTo: imageDescriptionView.trailingAnchor),
            accessoryLabel.bottomAnchor.constraint(equalTo: imageDescriptionView.bottomAnchor),

            imageDescriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            imageDescriptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            imageDescriptionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),

            favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: .smallSpacing),
            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            favoriteButton.widthAnchor.constraint(equalToConstant: 34),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.heightAnchor)
            ])
    }
}
