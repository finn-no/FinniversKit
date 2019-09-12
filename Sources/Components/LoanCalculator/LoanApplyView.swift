//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol LoanApplyViewModel {
    var conditionsText: String? { get }
    var applyText: String { get }
}

protocol LoanApplyViewDelegate: AnyObject {
    func loanApplyViewDidSelectApply(_ view: LoanApplyView)
}

class LoanApplyView: UIView {
    weak var delegate: LoanApplyViewDelegate?

    var isEnabled = true {
        didSet {
            applyButton.isEnabled = isEnabled
        }
    }

    // MARK: - Private subviews

    private lazy var conditionsText: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    private lazy var applyButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleApplyButtonTap), for: .touchUpInside)
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
        conditionsText.isHidden = model.conditionsText == nil
        applyButton.setTitle(model.applyText, for: .normal)
    }

    // MARK: - Private functions
    private func setup() {
        stackView.addArrangedSubview(conditionsText)
        stackView.addArrangedSubview(applyButton)
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    @objc private func handleApplyButtonTap() {
        delegate?.loanApplyViewDidSelectApply(self)
    }
}
