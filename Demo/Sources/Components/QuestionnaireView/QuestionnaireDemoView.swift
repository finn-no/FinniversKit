//
//  Copyright © FINN.no AS. All rights reserved.
//

import FinniversKit

public class QuestionnaireDemoView: UIView {
    private lazy var questionnaireView = QuestionnaireView(style: .normal(backgroundColor: .bgSecondary, primaryButtonIcon: UIImage(named: .webview)))

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        questionnaireView.delegate = self

        questionnaireView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(questionnaireView)
        questionnaireView.model = QuestionnaireDemoData()

        NSLayoutConstraint.activate([
            questionnaireView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            questionnaireView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.225),
            questionnaireView.centerXAnchor.constraint(equalTo: centerXAnchor),
            questionnaireView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension QuestionnaireDemoView: QuestionnaireViewDelegate {
    public func questionnaireViewDidSelectPrimaryButton(_ view: QuestionnaireView) {}

    public func questionnaireViewDidSelectCancelButton(_ view: QuestionnaireView) {
        UIView.animate(withDuration: 0.15) {
            self.questionnaireView.alpha = 0.0
        }
    }
}
