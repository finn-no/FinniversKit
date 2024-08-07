import FinniversKit
import DemoKit
import Warp

class MapAddressButtonDemoView: UIView, Demoable {

    var dismissKind: DismissKind { .button }

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, withAutoLayout: true)

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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200)
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
