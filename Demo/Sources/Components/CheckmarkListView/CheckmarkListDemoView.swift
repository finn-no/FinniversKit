import UIKit
import FinniversKit

class CheckmarkListDemoView: UIView, Tweakable {

    // MARK: - Internal properties

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "3 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 3))
        }),
        .init(title: "1 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 1))
        }),
        .init(title: "2 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 2))
        }),
        .init(title: "5 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 5))
        }),
    ]

    // MARK: - Private properties

    private lazy var checkmarkListView: CheckmarkListView = {
        let view = CheckmarkListView(withAutoLayout: true)
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
        addSubview(checkmarkListView)

        NSLayoutConstraint.activate([
            checkmarkListView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            checkmarkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            checkmarkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

// MARK: - CheckmarkListViewDelegate

extension CheckmarkListDemoView: CheckmarkListViewDelegate {
    func checkmarkListView(_ view: CheckmarkListView, didToggleItemAtIndex index: Int) {
        print("👉 Did toggle item at index \(index)")
    }
}

// MARK: - Private extensions

private extension Array where Element == CheckmarkItemModel {
    static func create(number: Int) -> [CheckmarkItemModel] {
        (0..<number).map {
            CheckmarkItemModel(
                title: "Jeg kan overlevere ved oppmøte",
                description: .plain("Du og kjøper gjør en egen avtale"),
                icon: UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate),
                isInitiallySelected: $0 == 0
            )
        }
    }
}
