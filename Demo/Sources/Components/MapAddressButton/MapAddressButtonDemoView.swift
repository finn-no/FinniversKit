import FinniversKit

class MapAddressButtonDemoView: UIView {

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews(createButtons())
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    private func createButtons() -> [MapAddressButton] {
        let titles = [
            "0001 Oslo",
            "Gateveien 123C, 0001 Oslo",
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean in nisl a nisl mattis vehicula et sed metus."
        ]

        return titles.map {
            let button = MapAddressButton(withAutoLayout: true)
            button.delegate = self
            button.setTitle($0)
            return button
        }
    }
}

// MARK: - MapAddressButtonDelegate

extension MapAddressButtonDemoView: MapAddressButtonDelegate {
    func mapAddressButtonWasSelected(_ button: MapAddressButton) {
        print("👉 Button was tapped")
    }
}
