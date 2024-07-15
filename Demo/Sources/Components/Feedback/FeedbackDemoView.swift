//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

class FeedbackDemoView: UIView, Demoable {

    var dismissKind: DismissKind { .button }

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
        stackView.spacing = Warp.Spacing.spacing100
        listItems.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    private lazy var gridFeedbackStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .fillEqually
        stackView.spacing = Warp.Spacing.spacing100
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

        backgroundColor = .background
        addSubview(switchViewsButton)
        addSubview(listFeedbackStackView)
        addSubview(gridFeedbackStackView)

        NSLayoutConstraint.activate([
            switchViewsButton.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            switchViewsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            switchViewsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            listFeedbackStackView.heightAnchor.constraint(equalToConstant: listItemHeight * 2 + Warp.Spacing.spacing100),
            listFeedbackStackView.topAnchor.constraint(equalTo: switchViewsButton.bottomAnchor, constant: Warp.Spacing.spacing100),
            listFeedbackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            listFeedbackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            gridFeedbackStackView.heightAnchor.constraint(equalToConstant: gridItemHeight),
            gridFeedbackStackView.topAnchor.constraint(equalTo: listFeedbackStackView.bottomAnchor, constant: Warp.Spacing.spacing100),
            gridFeedbackStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            gridFeedbackStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
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

private class SingleQuestionFeedback: FeedbackViewDelegate {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forStep stepIdentifier: String) {
        let step = FeedbackStep.finished
        feedbackView.configure(stepIdentifier: step, viewModel: step.viewModel)
    }

    func createFeedbackView() -> FeedbackView {
        let feedbackView = FeedbackView(withAutoLayout: true)
        feedbackView.delegate = self

        let initialStep = FeedbackStep.initial
        feedbackView.configure(stepIdentifier: initialStep, viewModel: initialStep.viewModel)
        return feedbackView
    }

    enum FeedbackStep: String {
        case initial
        case finished

        var viewModel: FeedbackViewModel {
            switch self {
            case .initial:
                FeedbackViewModel(title: "Tjohei! Hvordan var det å bruke det nye filteret?", positiveButtonTitle: "Gi tilbakemelding")
            case .finished:
                FeedbackViewModel(title: "Takk!\nVi setter pris på din tilbakemelding - det hjelper oss med å bli bedre")
            }
        }
    }
}

// MARK: - MultiQuestionFeedback

private class MultiQuestionFeedback: FeedbackViewDelegate {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forStep stepIdentifier: String) {
        let newState: FeedbackStep

        switch (FeedbackStep(rawValue: stepIdentifier), buttonType) {
        case (.initial, .positive):
            newState = .accept
        case (.initial, .negative):
            newState = .decline
        case (_, _):
            newState = .finished
        }

        feedbackView.configure(stepIdentifier: newState, viewModel: newState.viewModel)
    }

    func createFeedbackView() -> FeedbackView {
        let feedbackView = FeedbackView(withAutoLayout: true)
        feedbackView.delegate = self

        let initialStep = FeedbackStep.initial
        feedbackView.configure(stepIdentifier: initialStep, viewModel: initialStep.viewModel)
        return feedbackView
    }

    enum FeedbackStep: String {
        case initial
        case accept
        case decline
        case finished

        var viewModel: FeedbackViewModel {
            switch self {
            case .initial:
                FeedbackViewModel(title: "Liker du FINN appen?", positiveButtonTitle: "Ja!", negativeButtonTitle: "Niks.")
            case .accept:
                FeedbackViewModel(title: "Hurra! Hva med å gi oss noen stjerner i App Store?", positiveButtonTitle: "Klart!", negativeButtonTitle: "Nei")
            case .decline:
                FeedbackViewModel(title: "Å nei! Lyst til å hjelpe oss med å bli bedre?", positiveButtonTitle: "Klart!", negativeButtonTitle: "Nei")
            case .finished:
                FeedbackViewModel(title: "Takk!\nVi setter pris på din tilbakemelding - det hjelper oss med å bli bedre")
            }
        }
    }
}
