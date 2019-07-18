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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(receiptView)
        receiptView.fillInSuperview()
    }
}

extension ReceiptViewDemoView: ReceiptViewDelegate {
    func receipt(_ : ReceiptView, didTapNavigateToAd button: Button) {
        print("didTapNavigateToAd")
    }

    func receipt(_ : ReceiptView, didTapNavigateToMyAds button: Button) {
        print("didTapNavigateToMyAds")
    }

    func receipt(_ : ReceiptView, didTapCreateNewAd button: Button) {
        print("didTapCreateNewAd")
    }

    func receiptInsertViewBelowDetailText(_ : ReceiptView) -> UIView? {
        let questionnaireView = QuestionnaireView(style: .normal(backgroundColor: .ice, primaryButtonIcon: UIImage(named: .webview)))
        questionnaireView.translatesAutoresizingMaskIntoConstraints = false
        questionnaireView.delegate = self
        questionnaireView.model = QuestionnaireDemoData()
        return questionnaireView
    }
}

extension ReceiptViewDemoView: QuestionnaireViewDelegate {
    func questionnaireViewDidSelectPrimaryButton(_ view: QuestionnaireView) {
        print("questionnaireViewDidSelectPrimaryButton")
    }

    func questionnaireViewDidSelectCancelButton(_ view: QuestionnaireView) {
        print("questionnaireViewDidSelectCancelButton")

        UIView.animate(withDuration: 0.25) {
            view.alpha = 0.0
        }
    }
}
