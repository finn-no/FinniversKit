//
//  Copyright © 2019 FINN AS. All rights reserved.
//

protocol LoanApplyViewModel {
    var conditionsText: String { get }
    var applyText: String { get }
}

class LoanApplyView: UIView {
    // MARK: - Private subviews
    private lazy var conditionsText: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    private lazy var applyButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing

        return stackView
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Internal functions
    func configure(with model: LoanApplyViewModel) {
        conditionsText.text = model.conditionsText
        applyButton.setTitle(model.applyText, for: .normal)
    }

    // MARK: - Private functions
    private func setup() {
        stackView.addArrangedSubview(conditionsText)
        stackView.addArrangedSubview(applyButton)
        addSubview(stackView)
        stackView.fillInSuperview()
    }
}
