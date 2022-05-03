import UIKit
import FinniversKit

class CheckboxSelectionDemoView: UIView, Tweakable {

    // MARK: - Internal properties

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "3 items", action: { [weak self] in
            self?.checkboxSelectionView.configure(with: .create(number: 3))
        }),
        .init(title: "1 items", action: { [weak self] in
            self?.checkboxSelectionView.configure(with: .create(number: 1))
        }),
        .init(title: "2 items", action: { [weak self] in
            self?.checkboxSelectionView.configure(with: .create(number: 2))
        }),
        .init(title: "5 items", action: { [weak self] in
            self?.checkboxSelectionView.configure(with: .create(number: 5))
        }),
    ]

    // MARK: - Private properties

    private lazy var checkboxSelectionView: CheckboxSelectionView = {
        let view = CheckboxSelectionView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(checkboxSelectionView)

        NSLayoutConstraint.activate([
            checkboxSelectionView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            checkboxSelectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            checkboxSelectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

// MARK: - CheckboxSelectionViewDelegate

extension CheckboxSelectionDemoView: CheckboxSelectionViewDelegate {
    func checkboxSelectionView(_ view: CheckboxSelectionView, didToggleItemAtIndex index: Int) {
        print("👉 Did select item at index \(index)")
    }
}

// MARK: - Private extensions

private extension Array where Element == CheckboxItemModel {
    static func create(number: Int) -> [CheckboxItemModel] {
        (0..<number).map {
            CheckboxItemModel(
                title: "Jeg kan overlevere ved oppmøte",
                description: .plain("Du og kjøper gjør en egen avtale"),
                icon: UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate),
                isInitiallySelected: $0 == 0
            )
        }
    }
}
