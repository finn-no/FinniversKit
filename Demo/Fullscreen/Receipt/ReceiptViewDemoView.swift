//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class ReceiptViewDemoView: UIView {
    private lazy var receiptView: ReceiptView = {
        let receiptView = ReceiptView(delegate: self)
        receiptView.translatesAutoresizingMaskIntoConstraints = false
        receiptView.model = ReceiptViewDefaultData()
        return receiptView
    }()

    private lazy var questionnaireView: QuestionnaireView = {
        let questionnaireView = QuestionnaireView(style: .normal(backgroundColor: .ice, primaryButtonIcon: UIImage(named: .webview)))
        questionnaireView.translatesAutoresizingMaskIntoConstraints = false
        questionnaireView.delegate = self
        questionnaireView.model = QuestionnaireDemoData()
        return questionnaireView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        isUserInteractionEnabled = false

        addSubview(receiptView)

        NSLayoutConstraint.activate([
            receiptView.topAnchor.constraint(equalTo: topAnchor),
            receiptView.bottomAnchor.constraint(equalTo: bottomAnchor),
            receiptView.leadingAnchor.constraint(equalTo: leadingAnchor),
            receiptView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension ReceiptViewDemoView: ReceiptViewDelegate {
    func receipt(_ : ReceiptView, didTapNavigateToAd button: Button) {
        print("didTapCreateNewAd")
    }

    func receipt(_ : ReceiptView, didTapNavigateToMyAds button: Button) {
        print("didTapCreateNewAd")
    }

    func receipt(_ : ReceiptView, didTapCreateNewAd button: Button) {
        print("didTapCreateNewAd")
    }

    func receiptInsertViewBelowDetailText(_ : ReceiptView) -> UIView? {
        return questionnaireView
    }
}

extension ReceiptViewDemoView: QuestionnaireViewDelegate {
    func questionnaireViewDidSelectPrimaryButton(_ view: QuestionnaireView) {
        print("questionnaireViewDidSelectPrimaryButton")
    }

    func questionnaireViewDidSelectCancelButton(_ view: QuestionnaireView) {
        UIView.animate(withDuration: 0.25) {
            self.questionnaireView.alpha = 0.0
        }
    }
}
