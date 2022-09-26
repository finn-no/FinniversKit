import FinniversKit

class ScrollableTabDemoView: UIView {

    // MARK: - Private properties

    lazy var sideScrollableView = ScrollableTabView(withAutoLayout: true)

    lazy var label: Label = {
        let label = Label(
            style: .bodyRegular,
            withAutoLayout: true
        )
        label.textAlignment = .center
        label.text = "Select an item..."
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(sideScrollableView)
        addSubview(label)

        NSLayoutConstraint.activate([
            sideScrollableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sideScrollableView.topAnchor.constraint(equalTo: topAnchor),
            sideScrollableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: sideScrollableView.bottomAnchor, constant: 50),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let viewModel = ScrollableTabViewModel(
            items: [
                .create(title: "Alle"),
                .create(title: "Aktiv (3)"),
                .create(title: "Påbegynte (17)"),
                .create(title: "Avvist (2)"),
                .create(title: "Lorem ipsum (42)")
            ]
        )
        sideScrollableView.configure(with: viewModel)
        sideScrollableView.delegate = self
    }
}

// MARK: - ScrollableTabViewDelegate

extension ScrollableTabDemoView: ScrollableTabViewDelegate {
    func scrollableTabViewDidTapItem(
        _ sidescrollableView: ScrollableTabView,
        item: ScrollableTabViewModel.Item,
        itemIndex: Int
    ) {
        label.text = "\(item.title) was selected 🎉"
    }
}

// MARK: - Private extensions

private extension ScrollableTabViewModel.Item {
    static func create(title: String) -> Self {
        self.init(identifier: title, title: title)
    }
}
