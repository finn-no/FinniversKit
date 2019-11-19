//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class VersionInfoView: UIView {

    // MARK: - Private properties

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .finnLogoSimple)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var versionLabel: UILabel = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(withText text: String?) {
        versionLabel.text = text

        frame.size = systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(logoImageView)
        addSubview(versionLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 58),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            versionLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: .mediumSpacing),
            versionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        ])
    }
}
