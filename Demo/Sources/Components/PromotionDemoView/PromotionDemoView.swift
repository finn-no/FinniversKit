import UIKit
import FinniversKit

class PromotionDemoView: UIView {
    private lazy var viewModels: [PromotionViewModel] = [christmasPromoViewModel, hjerteromPromoViewModel]

    private let christmasPromoViewModel = PromotionViewModel(
        title: "Hjelp til jul hos FINN",
        image: UIImage(named: .christmasPromotion),
        imageAlignment: .trailing,
        primaryButtonTitle: "Be om eller tilby hjelp",
        secondaryButtonTitle: "Se annonsene"
    )

    private let hjerteromPromoViewModel = PromotionViewModel(
        title: "Hjerterom - hjelp til flyktninger",
        text: "Under Hjerterom kan du finne informasjon om hvordan du kan hjelpe flyktninger som kommer til Norge.",
        image: UIImage(named: .hjerterom),
        imageAlignment: .fullWidth,
        imageBackgroundColor: .primaryBlue,
        primaryButtonTitle: "Gå til Hjerterom"
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
            let view = ChristmasPromotionView(viewModel: viewModel)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
}

extension PromotionDemoView: PromotionViewDelegate {
    func promotionViewTapped(_ promotionView: ChristmasPromotionView) {
        print("Promo tapped")
    }

    func promotionView(_ promotionView: ChristmasPromotionView, didSelect action: ChristmasPromotionView.Action) {
        print("Selected : \(action)")
    }
}
