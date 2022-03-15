import UIKit
import FinniversKit

class ChristmasPromotionDemoView: UIView {
    private lazy var promotionView: ChristmasPromotionView = {
        let model = ChristmasPromotionViewModel(title: "Hjelp til jul hos FINN",
                                                helpButtonTitle: "Be om eller tilby hjelp",
                                                adsButtonTitle: "Se annonsene")
        let view = ChristmasPromotionView(model: model)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(promotionView)
    
        NSLayoutConstraint.activate([
            promotionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            promotionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            promotionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            promotionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            promotionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension ChristmasPromotionDemoView: PromotionViewDelegate {
    func christmasPromotionView(_ promotionView: ChristmasPromotionView, didSelect action: ChristmasPromotionView.Action) {
        print("Selected : \(action)")
    }
}
