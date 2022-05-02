import UIKit
import FinniversKit

class CheckboxSelectionDemoView: UIView {

    // MARK: - Public properties



    // MARK: - Private properties

    private lazy var checkboxSelectionView: CheckboxSelectionView = {
        let view = CheckboxSelectionView(withAutoLayout: true)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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

        checkboxSelectionView.configure(with: [
            .init(
                title: "Jeg kan overlevere ved oppmøte",
                description: .plain("Du og kjøper gjør en egen avtale"),
                icon: UIImage(named: .contract),
                isInitiallySelected: true
            ),
            .init(
                title: "Jeg kan sende",
                description: .plain("Send og ta betalt gjennom FINN"),
                icon: UIImage(named: .contract),
                isInitiallySelected: false
            )
        ])
    }
}
