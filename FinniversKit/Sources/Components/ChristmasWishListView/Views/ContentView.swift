//
//  Copyright © 2019 FINN AS. All rights reserved.
//
import Warp

protocol ChristmasWishListContentViewDelegate: AnyObject {
    func christmasWishListContentDidSelectAccessoryButton(_ view: ChristmasWishListView.ContentView)
}

extension ChristmasWishListView {
    class ContentView: UIView {
        // MARK: - Public properties
        weak var delegate: ChristmasWishListContentViewDelegate?

        // MARK: - Private properties
        private lazy var titleLabel: UILabel = {
            let label = UILabel(withAutoLayout: true)
            let font = UIFont.font(ofSize: 22, weight: .bold, textStyle: .title2)
            label.font = font
            label.textAlignment = .center
            label.textColor = .text
            label.adjustsFontForContentSizeCategory = true
            label.numberOfLines = 0
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            return label
        }()

        private lazy var bodyTextLabel: UILabel = {
            let label = Label(style: .body, withAutoLayout: true)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.setContentHuggingPriority(.defaultHigh, for: .vertical)
            label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
            return label
        }()

        private lazy var accessoryButton: UIButton = {
            let button = Button(style: .link, size: .small, withAutoLayout: true)
            button.titleLabel?.font = .captionStrong
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            button.addTarget(self, action: #selector(handleTapOnAccessoryButton), for: .touchUpInside)
            button.setContentHuggingPriority(.defaultHigh, for: .vertical)
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

        func configure(with viewModel: ChristmasWishListViewModel.Page) {
            titleLabel.text = viewModel.title
            bodyTextLabel.text = viewModel.text
            accessoryButton.isHidden = viewModel.accessoryButtonTitle == nil
            accessoryButton.setTitle(viewModel.accessoryButtonTitle, for: .normal)
        }

        // MARK: - Private methods

        private func setup() {
            backgroundColor = .background
            let spacing = Warp.Spacing.spacing200 * 1.5
            layoutMargins = UIEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)

            addSubview(titleLabel)
            addSubview(bodyTextLabel)
            addSubview(accessoryButton)

            let margins = layoutMarginsGuide

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: margins.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

                bodyTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
                bodyTextLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                bodyTextLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor),

                accessoryButton.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: Warp.Spacing.spacing200),
                accessoryButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                accessoryButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                accessoryButton.heightAnchor.constraint(greaterThanOrEqualToConstant: .spacingXL),
                accessoryButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        }

        @objc private func handleTapOnAccessoryButton() {
            delegate?.christmasWishListContentDidSelectAccessoryButton(self)
        }
    }
}
