//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class HyperlinkTextViewDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Hyperlinks yeah", action: { [weak self] in
            self?.configureHyper()
        })
    ]

    // MARK: - Private properties

    private lazy var hyperlinkTextView = HyperlinkTextView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        var viewModel = HyperlinkTextViewViewModel(
            text: "Med å gjøre en <tag1>forespørsel</tag1> aksepterer du også <tag2>vilkårene for fiks, ferdig frakt og betaling</tag2>.",
            hyperlinks: [
                HyperlinkTextViewViewModel.Hyperlink(
                    hyperlink: "tag1",
                    action: "test://foobar"
                ),
                HyperlinkTextViewViewModel.Hyperlink(
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

extension HyperlinkTextViewDemoView: HyperlinkTextViewViewModelDelegate {
    public func didTapHyperlinkAction(_ action: String) {
        print("Action \(action) was tapped.")
    }
}
