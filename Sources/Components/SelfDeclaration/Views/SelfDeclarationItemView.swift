//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public class SelfDeclarationItemView: UIView {

    // MARK: - Private properties

    private lazy var questionAndAnswerLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    private lazy var explanationLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(questionAndAnswerLabel)
        addSubview(explanationLabel)

        NSLayoutConstraint.activate([
            questionAndAnswerLabel.topAnchor.constraint(equalTo: topAnchor),
            questionAndAnswerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionAndAnswerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            explanationLabel.topAnchor.constraint(equalTo: questionAndAnswerLabel.bottomAnchor, constant: .mediumSpacing),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            explanationLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: SelfDeclarationItemViewModel) {
        questionAndAnswerLabel.text = "\(viewModel.question): \(viewModel.answer)"
        explanationLabel.text = viewModel.explanation
    }
}
