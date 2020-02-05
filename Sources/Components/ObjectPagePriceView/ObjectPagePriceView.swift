//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public class ObjectPagePriceView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel = Label(style: .body, withAutoLayout: true)
    private lazy var totalPriceLabel = Label(style: .title3Strong, withAutoLayout: true)

    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, linkStackView])
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, totalPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var linkStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(wrapperStackView)
        wrapperStackView.fillInSuperview()
    }
}
