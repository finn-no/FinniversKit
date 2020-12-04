import FinniversKit

class NavigationLinkViewDemoView: UIView {

    private lazy var view: NavigationLinkView = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.text = "This view can be configured to contain whatever view you'd like."
        label.numberOfLines = 0
        let view = NavigationLinkView(withSubview: label, withAutoLayout: true)
        return view
    }()

    private lazy var secondView: NavigationLinkView = {
        let label = Label(style: .title3, withAutoLayout: true)
        label.text = "For example, you can insert a yellow view like this."
        label.backgroundColor = .yellow
        label.numberOfLines = 0
        let view = NavigationLinkView(withSubview: label, withAutoLayout: true)
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([view, secondView])
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
        ])
    }

}
