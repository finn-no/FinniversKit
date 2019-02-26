//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class FeedbackDemoView: UIView {

    // MARK: - Private properties

    private let singleQuestionFeedback = SingleQuestionFeedback()
    private let multiQuestionFeedback = MultiQuestionFeedback()

    private var hasSwitchedViews = false

    private let gridItemHeight: CGFloat = 300
    private let listItemHeight: CGFloat = 100

    private lazy var listItems = [singleQuestionFeedback.createFeedbackView(), multiQuestionFeedback.createFeedbackView()]
    private lazy var gridItems = [singleQuestionFeedback.createFeedbackView(), multiQuestionFeedback.createFeedbackView()]

    private lazy var listFeedbackStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        listItems.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var gridFeedbackStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .fillEqually
        stackView.spacing = .mediumSpacing
        gridItems.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var switchViewsButton: UIButton = {
        let button = Button(style: .callToAction, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Switch grid / list views", for: .normal)
        button.addTarget(self, action: #selector(switchViewsButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(switchViewsButton)
        addSubview(listFeedbackStackView)
        addSubview(gridFeedbackStackView)

        NSLayoutConstraint.activate([
            switchViewsButton.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            switchViewsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            switchViewsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            listFeedbackStackView.heightAnchor.constraint(equalToConstant: listItemHeight * 2 + .mediumSpacing),
            listFeedbackStackView.topAnchor.constraint(equalTo: switchViewsButton.bottomAnchor, constant: .mediumSpacing),
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

    // MARK: - Private methods

    @objc private func switchViewsButtonTapped() {
        switchViewsButton.isEnabled = false

        listItems.forEach { $0.removeFromSuperview() }
        gridItems.forEach { $0.removeFromSuperview() }

        if hasSwitchedViews {
            listItems.forEach { listFeedbackStackView.addArrangedSubview($0) }
            gridItems.forEach { gridFeedbackStackView.addArrangedSubview($0) }
        } else {
            gridItems.forEach { listFeedbackStackView.addArrangedSubview($0) }
            listItems.forEach { gridFeedbackStackView.addArrangedSubview($0) }
        }

        hasSwitchedViews = !hasSwitchedViews
        switchViewsButton.isEnabled = true
    }
}

// MARK: - SingleQuestionFeedback

class SingleQuestionFeedback: FeedbackViewDelegate {
    let viewModels: [FeedbackView.State: FeedbackViewModel] = [
        .initial: FeedbackViewModel(title: "Tjohei! Hvordan var det å bruke det nye filteret?", positiveButtonTitle: "Gi tilbakemelding"),
        .finished: FeedbackViewModel(title: "Takk!\nVi setter pris på din tilbakemelding - det hjelper oss med å bli bedre")
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
        .accept: FeedbackViewModel(title: "Hurra! Hva med å gi oss noen stjerner i App Store?", positiveButtonTitle: "Klart!", negativeButtonTitle: "Nei"),
        .decline: FeedbackViewModel(title: "Å nei! Lyst til å hjelpe oss med å bli bedre?", positiveButtonTitle: "Klart!", negativeButtonTitle: "Nei"),
        .finished: FeedbackViewModel(title: "Takk!\nVi setter pris på din tilbakemelding - det hjelper oss med å bli bedre")
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
