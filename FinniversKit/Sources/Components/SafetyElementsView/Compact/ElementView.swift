//
//  Copyright © 2020 FINN AS. All rights reserved.
//

extension SafetyElementsView {
    class ElementView: UIView {
        weak var delegate: SafetyElementContentViewDelegate? {
            didSet {
                contentView.delegate = delegate
            }
        }

        // MARK: - Private properties
        private lazy var headerStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .horizontal
            stackView.alignment = .center
            stackView.spacing = .spacingS
            return stackView
        }()

        private lazy var outerStackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = .spacingS
            stackView.distribution = .equalSpacing
            return stackView
        }()

        private lazy var titleLabel: Label = {
            let label = Label(style: .captionStrong, withAutoLayout: true)
            label.textAlignment = .left
            return label
        }()

        private lazy var iconImageView: UIImageView = {
            let imageView = UIImageView(withAutoLayout: true)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .inactiveSafetyIconTint
            imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return imageView
        }()

        private lazy var contentView: ElementContentView = {
            let view = ElementContentView(withAutoLayout: true)
            view.layoutMargins = .zero
            return view
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

        // MARK: - Internal methods

        func configure(with viewModel: SafetyElementViewModel, isLastElement: Bool) {
            iconImageView.image = viewModel.icon.withRenderingMode(.alwaysTemplate)
            titleLabel.text = viewModel.title
            layoutMargins.bottom = isLastElement ? 0 : .spacingM
            contentView.configure(with: viewModel)
        }

        // MARK: - Private methods

        private func setup() {
            headerStackView.addArrangedSubview(iconImageView)
            headerStackView.addArrangedSubview(titleLabel)

            outerStackView.addArrangedSubview(headerStackView)
            outerStackView.addArrangedSubview(contentView)

            addSubview(outerStackView)
            outerStackView.fillInSuperviewLayoutMargins()

            layoutMargins = UIEdgeInsets(top: .spacingM)
        }
    }
}
