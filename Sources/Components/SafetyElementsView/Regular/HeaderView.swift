//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

extension SafetyElementsView {
    class HeaderView: UIView {
        var contentBackgroundColor: UIColor? = .bgTertiary {
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
                    iconImageView.tintColor = .primaryBlue
                } else {
                    iconImageView.tintColor = .stone
                    titleView.backgroundColor = .clear
                }
            }
        }

        required init?(coder aDecoder: NSCoder) { fatalError() }

        private lazy var outerStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = .mediumSpacing
            stackView.isUserInteractionEnabled = true
            return stackView
        }()

        private lazy var iconImageView: UIImageView = {
            let imageView = UIImageView(withAutoLayout: true)
            imageView.isUserInteractionEnabled = true
            return imageView
        }()

        private lazy var titleView: UIView = {
            let view = UIView(withAutoLayout: true)
            view.backgroundColor = .bgTertiary
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.layer.cornerRadius = .mediumSpacing
            view.layoutMargins = UIEdgeInsets(vertical: .mediumSpacing, horizontal: .mediumLargeSpacing)
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

            outerStackView.addArrangedSubview(iconImageView)
            outerStackView.addArrangedSubview(titleView)
            addSubview(outerStackView)
            outerStackView.fillInSuperview()
        }
    }
}
