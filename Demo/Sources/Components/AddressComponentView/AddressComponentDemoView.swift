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
            .regular(.init(value: "Vei veien", placeholder: "Gatenavn")),
            .regular(.init(value: "123", placeholder: "Gatenummer")),
            .regular(.init(value: "1", placeholder: "Etasje")),
            .regular(.init(value: nil, placeholder: "Leilighet")),
            .postalCodeAndPlace(
                postalCode: .init(value: "0001", placeholder: "Postnummer"),
                postalPlace: .init(value: "Oslo", placeholder: "Poststed")
            )
        ]
    }
}
