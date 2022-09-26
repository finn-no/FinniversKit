import UIKit

public protocol AddressComponentViewDelegate: AnyObject {
    func addressComponentView(_ view: AddressComponentView, didSelectComponentAtIndex index: Int)
}

public class AddressComponentView: UIView {

    // MARK: - Private properties

    private weak var delegate: AddressComponentViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: 0, withAutoLayout: true)

    // MARK: - Init

    public init(delegate: AddressComponentViewDelegate, withAutoLayout: Bool) {
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with componentKinds: [AddressComponentKind]) {
        let addressComponentViews = componentKinds.map { kind -> UIView in
            switch kind {
            case .regular(let model):
                let view = AddressComponentFieldView(withAutoLayout: true)
                view.configure(with: model)

                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleComponentTap))
                view.addGestureRecognizer(tapGestureRecognizer)

                return view
            case .postalCodeAndPlace(postalCode: let postalCodeModel, postalPlace: let postalPlaceModel):
                let view = AddressComponentPostalFieldView(withAutoLayout: true)
                view.configure(postalCodeModel: postalCodeModel, postalPlaceModel: postalPlaceModel, showHairline: false)
                return view
            }
        }

        stackView.removeArrangedSubviews()
        stackView.addArrangedSubviews(addressComponentViews)
    }

    // MARK: - Actions

    @objc private func handleComponentTap(_ gestureRecognizer: UIGestureRecognizer) {
        guard
            let view = gestureRecognizer.view as? AddressComponentFieldView,
            let viewIndex = stackView.arrangedSubviews.firstIndex(of: view)
        else { return }

        delegate?.addressComponentView(self, didSelectComponentAtIndex: viewIndex)
    }
}
