import FinniversKit

class ViewingsListDemoView: UIView {

    private lazy var viewingsListView = ViewingsListView(withAutoLayout: true)

    private let viewModel = ViewingsListViewModel(
        title: "Visninger",
        addToCalendarButtonTitle: "Legg til i kalender",
        viewings: [
            ViewingItemViewModel(weekday: "Søndag", month: "JAN", day: "19", timeInterval: "Kl. 12.00 - 13.00", note: "Visningen streames"),
            ViewingItemViewModel(weekday: "Mandag", month: "JAN", day: "20", timeInterval: "Kl. 18.30 - 19.30", note: nil)
        ],
        note: "Velkommen til visning!"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        viewingsListView.delegate = self
        addSubview(viewingsListView)
        viewingsListView.configure(with: viewModel)

        NSLayoutConstraint.activate([
            viewingsListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            viewingsListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            viewingsListView.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewingsListView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - ViewingsViewDelegate

extension ViewingsListDemoView: ViewingsListViewDelegate {
    func viewingsListViewDidSelectAddToCalendarButton(_ view: ViewingsListView, forIndex index: Int) {
        print("👉 Did select viewing at index \(index)")
    }
}
