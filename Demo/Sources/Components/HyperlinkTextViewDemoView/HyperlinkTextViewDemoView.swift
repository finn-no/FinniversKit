import UIKit
import FinniversKit
import DemoKit

class HyperlinkTextViewDemoView: UIView {

    // MARK: - Private properties

    private lazy var hyperlinkTextView = HyperlinkTextView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        addSubview(hyperlinkTextView)

        NSLayoutConstraint.activate([
            hyperlinkTextView.centerYAnchor.constraint(equalTo: centerYAnchor),
            hyperlinkTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            hyperlinkTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Configure

    private func configureHyper() {
        let viewModel = HyperlinkTextViewModel(
            text: "Med å gjøre en <tag1>forespørsel</tag1> aksepterer du også <tag2>vilkårene for fiks, ferdig frakt og betaling</tag2>.",
            hyperlinks: [
                HyperlinkTextViewModel.Hyperlink(
                    hyperlink: "tag1",
                    action: "test://foobar"
                ),
                HyperlinkTextViewModel.Hyperlink(
                    hyperlink: "tag2",
                    action: "test://blah"
                )
            ]
        )
        viewModel.delegate = self
        hyperlinkTextView.font = .caption
        hyperlinkTextView.configure(with: viewModel)
    }

    // MARK: - Actions

    @objc private func handleTap() {
        endEditing(true)
    }
}

extension HyperlinkTextViewDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case hyperlinksYeah
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .hyperlinksYeah:
            configureHyper()
        }
    }
}

extension HyperlinkTextViewDemoView: HyperlinkTextViewViewModelDelegate {
    func didTapHyperlinkAction(_ action: String) {
        print("Action \(action) was tapped.")
    }
}
