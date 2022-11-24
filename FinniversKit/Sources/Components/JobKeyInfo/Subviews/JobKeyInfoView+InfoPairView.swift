import Foundation

extension JobKeyInfoView {
    class InfoPairView: UIView {

        // MARK: - Private properties

        private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)

        private lazy var titleLabel: Label = {
            let label = Label(style: .bodyStrong, withAutoLayout: true)
            label.numberOfLines = 0
            return label
        }()

        private lazy var valueLabel: Label = {
            let label = Label(style: .body, withAutoLayout: true)
            label.textAlignment = .right
            label.numberOfLines = 0
            return label
        }()

        // MARK: - Init

        init(infoPair: InfoPair, withAutoLayout: Bool) {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = !withAutoLayout
            setup(infoPair: infoPair)
        }

        required init?(coder: NSCoder) { fatalError() }

        // MARK: - Setup

        private func setup(infoPair: InfoPair) {
            titleLabel.text = infoPair.title
            valueLabel.text = infoPair.value

            stackView.addArrangedSubviews([titleLabel, valueLabel])
            addSubview(stackView)
            stackView.fillInSuperview()
        }
    }
}
