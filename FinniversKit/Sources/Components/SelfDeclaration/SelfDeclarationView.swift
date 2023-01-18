//
//  SelfDeclarationView.swift
//  FinniversKit
//

public class SelfDeclarationView: UIView {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingL
        return stackView
    }()

    func getQuestionStackView(with subviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingXS
        stackView.addArrangedSubviews(subviews)
        return stackView
    }

    func getQuestionLabel(with text: String) -> Label {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.text = text
        return label
    }

    func getAnswerLabel(with text: String) -> Label {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.text = text
        return label
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: SelfDeclarationViewModel) {
        stackView.removeArrangedSubviews()

        viewModel.items.forEach {
            let questionLabel = getQuestionLabel(with: $0.question)
            let answerLabel = getAnswerLabel(with: "\($0.answer) \($0.explanation)")
            let questionStackView = getQuestionStackView(with: [questionLabel, answerLabel])
            stackView.addArrangedSubview(questionStackView)
        }
    }
}
