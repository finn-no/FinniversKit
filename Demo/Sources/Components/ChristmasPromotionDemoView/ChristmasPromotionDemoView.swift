//
//  ChristmasPromotionDemoView.swift
//  Demo
//

import UIKit
import FinniversKit

class ChristmasPromotionDemoView: UIView {
    private lazy var promotionView: ChristmasPromotionView = {
        let view = ChristmasPromotionView(withAutoLayout: true)
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
            promotionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            promotionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            promotionView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
}

extension ChristmasPromotionDemoView: PromotionViewDelegate {
    func didSelectPromotion(_ promotion: ChristmasPromotionView) {
        print("Promotion selected")
    }
}
