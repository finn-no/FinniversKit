import UIKit
import FinniversKit

class PromotionDemoView: UIView {
    private lazy var viewModels: [PromotionViewModel] = [christmasPromoViewModel, hjerteromPromoViewModel]

    private let christmasPromoViewModel = PromotionViewModel(
        title: "Hjelp til jul hos FINN",
        image: UIImage(named: .christmasPromotion),
        primaryButtonTitle: "Be om eller tilby hjelp",
        secondaryButtonTitle: "Se annonsene"
    )

    private let hjerteromPromoViewModel = PromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        image: UIImage(named: .christmasPromotion),
        primaryButtonTitle: nil,
        secondaryButtonTitle: nil
    )

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingL, withAutoLayout: true)
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        for viewModel in viewModels {
            let view = PromotionView(model: viewModel)
            view.delegate = self
            view.heightAnchor.constraint(equalToConstant: 150).isActive = true
            stackView.addArrangedSubview(view)
        }
    }
}

extension PromotionDemoView: PromotionViewDelegate {
    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action) {
        print("Selected : \(action)")
    }
}
