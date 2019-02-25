//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FeedbackDemoView: UIView {
    private let singleQuestionFeedback = SingleQuestionFeedback()
    private let multiQuestionFeedback = MultiQuestionFeedback()

    private let gridItemHeight: CGFloat = 300
    private let listItemHeight: CGFloat = 100

    lazy var listFeedbackStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        stackView.addArrangedSubview(singleQuestionFeedback.createFeedbackView())
        stackView.addArrangedSubview(multiQuestionFeedback.createFeedbackView())
        return stackView
    }()

    lazy var gridFeedbackStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .fillEqually
        stackView.spacing = .mediumSpacing
        stackView.addArrangedSubview(singleQuestionFeedback.createFeedbackView())
        stackView.addArrangedSubview(multiQuestionFeedback.createFeedbackView())
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(listFeedbackStackView)
        addSubview(gridFeedbackStackView)

        NSLayoutConstraint.activate([
            listFeedbackStackView.heightAnchor.constraint(equalToConstant: listItemHeight * 2 + .mediumSpacing),
            listFeedbackStackView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            listFeedbackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            listFeedbackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            gridFeedbackStackView.heightAnchor.constraint(equalToConstant: gridItemHeight),
            gridFeedbackStackView.topAnchor.constraint(equalTo: listFeedbackStackView.bottomAnchor, constant: .mediumSpacing),
            gridFeedbackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            gridFeedbackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SingleQuestionFeedback

class SingleQuestionFeedback: FeedbackViewDelegate {
    let viewModels: [FeedbackView.State: FeedbackViewModel] = [
        .initial: FeedbackViewModel(title: "Tjohei! Hvordan var det å bruke det nye filteret?", positiveButtonTitle: "Gi rask tilbakemelding"),
        .finished: FeedbackViewModel(title: "Tusen takk for hjelpen! Med din tilbakemelding hjelper du oss å lage en enda bedre tjeneste for hele befolkningen.")
    ]

    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State) {
        feedbackView.setState(.finished, withViewModel: viewModels[.finished]!)
    }

    func createFeedbackView() -> FeedbackView {
        let feedbackView = FeedbackView(withAutoLayout: true)
        feedbackView.delegate = self
        feedbackView.setState(.initial, withViewModel: viewModels[.initial]!)
        return feedbackView
    }
}

// MARK: - MultiQuestionFeedback

class MultiQuestionFeedback: FeedbackViewDelegate {
    let viewModels: [FeedbackView.State: FeedbackViewModel] = [
        .initial: FeedbackViewModel(title: "Liker du FINN appen?", positiveButtonTitle: "Ja!", negativeButtonTitle: "Niks."),
        .accept: FeedbackViewModel(title: "Hurra! Hva med å gi oss noen stjerner i App Store?", positiveButtonTitle: "Selvfølgelig!", negativeButtonTitle: "Nei, takk"),
        .decline: FeedbackViewModel(title: "Å nei! Lyst til å hjelpe oss med å bli bedre?", positiveButtonTitle: "Selvfølgelig!", negativeButtonTitle: "Nei, takk"),
        .finished: FeedbackViewModel(title: "Takk! Vi setter pris på din tilbakemelding - det hjelper oss med å bli bedre")
    ]

    public func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State) {
        let newState: FeedbackView.State
        switch (state, buttonType) {
        case (.initial, .positive):
            newState = .accept
        case (.initial, .negative):
            newState = .decline
        case (_, _):
            newState = .finished
        }

        guard let viewModel = viewModels[newState] else { return }
        feedbackView.setState(newState, withViewModel: viewModel)
    }

    func createFeedbackView() -> FeedbackView {
        let feedbackView = FeedbackView(withAutoLayout: true)
        feedbackView.delegate = self
        feedbackView.setState(.initial, withViewModel: viewModels[.initial]!)
        return feedbackView
    }
}
