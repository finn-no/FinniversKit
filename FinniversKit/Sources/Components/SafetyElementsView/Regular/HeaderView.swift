//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit
import Warp

extension SafetyElementsView {
    class HeaderView: UIView {
        var contentBackgroundColor: UIColor? = .backgroundInfoSubtle {
            didSet {
                if isActive {
                    titleView.backgroundColor = contentBackgroundColor
                }
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        var isActive: Bool = false {
            didSet {
                if isActive {
                    titleView.backgroundColor = contentBackgroundColor
                    iconImageView.tintColor = .backgroundPrimary
                } else {
                    iconImageView.tintColor = .icon
                    titleView.backgroundColor = .clear
                }
            }
        }

        required init?(coder aDecoder: NSCoder) { fatalError() }

        private lazy var outerStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = Warp.Spacing.spacing100
            stackView.isUserInteractionEnabled = true
            return stackView
        }()

        private lazy var iconImageView: UIImageView = {
            let imageView = UIImageView(withAutoLayout: true)
            imageView.isUserInteractionEnabled = true
            imageView.contentMode = .scaleAspectFit
            imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
            imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return imageView
        }()

        private lazy var titleView: UIView = {
            let view = UIView(withAutoLayout: true)
            view.backgroundColor = .backgroundSubtle
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.layer.cornerRadius = Warp.Spacing.spacing100
            view.layoutMargins = UIEdgeInsets(vertical: Warp.Spacing.spacing100, horizontal: Warp.Spacing.spacing200)
            return view
        }()

        private lazy var titleLabel: Label = {
            let label = Label(style: .captionStrong, withAutoLayout: true)
            label.textAlignment = .left
            return label
        }()

        func configure(with viewModel: SafetyElementViewModel) {
            iconImageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)
            titleLabel.text = viewModel.title
        }

        private func setup() {
            isUserInteractionEnabled = true

            titleView.addSubview(titleLabel)
            titleLabel.fillInSuperviewLayoutMargins()

            NSLayoutConstraint.activate([
                iconImageView.heightAnchor.constraint(equalToConstant: Warp.Spacing.spacing200 * 1.5),
                iconImageView.widthAnchor.constraint(equalToConstant: Warp.Spacing.spacing200 * 1.5),
            ])

            outerStackView.addArrangedSubview(iconImageView)
            outerStackView.addArrangedSubview(titleView)
            addSubview(outerStackView)
            outerStackView.fillInSuperview()
        }
    }
}
