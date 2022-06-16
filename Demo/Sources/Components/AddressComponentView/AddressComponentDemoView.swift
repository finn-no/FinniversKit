import FinniversKit

class AddressComponentDemoView: UIView {

    // MARK: - Private properties

    private lazy var addressComponentView = AddressComponentView(delegate: self, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addressComponentView.configure(with: .demoItems)
        addSubview(addressComponentView)

        NSLayoutConstraint.activate([
            addressComponentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            addressComponentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            addressComponentView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - AddressComponentViewDelegate

extension AddressComponentDemoView: AddressComponentViewDelegate {
    func addressComponentView(_ view: AddressComponentView, didSelectComponentAtIndex index: Int) {
        print("👉 Did select component at index: \(index)")
    }
}

// MARK: - Private extensions

private extension Array where Element == AddressComponentKind {
    static var demoItems: [AddressComponentKind] {
        [
            .regular(.init(value: "Vei veien", placeholder: "Gatenavn", noValueAccessibilityLabel: "Ikke fylt ut")),
            .regular(.init(value: "123", placeholder: "Gatenummer", noValueAccessibilityLabel: "Ikke fylt ut")),
            .regular(.init(value: "1", placeholder: "Etasje", noValueAccessibilityLabel: "Ikke fylt ut")),
            .regular(.init(value: nil, placeholder: "Leilighet", noValueAccessibilityLabel: "Ikke fylt ut")),
            .postalCodeAndPlace(
                postalCode: .init(value: "0001", placeholder: "Postnummer", noValueAccessibilityLabel: "Fyll inn adresse først"),
                postalPlace: .init(value: "Oslo", placeholder: "Poststed", noValueAccessibilityLabel: "Fyll inn adresse først")
            )
        ]
    }
}
