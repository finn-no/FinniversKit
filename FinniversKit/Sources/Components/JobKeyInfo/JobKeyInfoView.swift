import UIKit

public class JobKeyInfoView: UIView {
    public typealias InfoPair = (title: String, value: String)

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    // MARK: - Init

    public init(infoPairs: [InfoPair], withAutoLayout: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup(infoPairs: infoPairs)
    }

    public required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup

    private func setup(infoPairs: [InfoPair]) {
        infoPairs.enumerated().forEach { index, infoPair in
            if index != 0 {
                stackView.addArrangedSubview(Separator(withAutoLayout: true))
            }

            stackView.addArrangedSubview(InfoPairView(infoPair: infoPair, withAutoLayout: true))
        }

        addSubview(stackView)
        stackView.fillInSuperview()
    }
}
