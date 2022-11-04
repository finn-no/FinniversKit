//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

public class TextViewDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Scrollable", action: { [weak self] in
            self?.configure(placeholderText: "Scrollable TextView")
        }),
        .init(title: "Non-scrollable", action: { [weak self] in
            self?.configure(placeholderText: "Non-scrollable TextView", isScrollable: false)
        }),
        .init(title: "Underline hidden", action: { [weak self] in
            self?.configure(placeholderText: "Placeholder", hideUnderLine: true)
        }),
        .init(title: "Other background color", action: { [weak self] in
            self?.configure(placeholderText: "Placeholder", backgroundColor: .bgTertiary)
        }),
        .init(title: "Other background color and underline hidden", action: { [weak self] in
            self?.configure(placeholderText: "Placeholder", hideUnderLine: true, backgroundColor: .bgTertiary)
        }),
        .init(title: "Hyperlinks yeah", action: { [weak self] in
            self?.configureHyper()
        })
    ]

    // MARK: - Private properties

    private lazy var textView = TextView(withAutoLayout: true)

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

        textView.delegate = self
        addSubview(textView)

        addSubview(hyperlinkTextView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            textView.bottomAnchor.constraint(equalTo: centerYAnchor),

            hyperlinkTextView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 50),
            hyperlinkTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            hyperlinkTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Configure

    private func configure(
        placeholderText: String,
        isScrollable: Bool = true,
        hideUnderLine: Bool = false,
        backgroundColor: UIColor = .bgSecondary
    ) {
        textView.placeholderText = placeholderText
        textView.isScrollEnabled = isScrollable
        textView.configure(shouldHideUnderLine: hideUnderLine)
        textView.configure(textViewBackgroundColor: backgroundColor)
    }

    private func configureHyper() {
        var viewModel = HyperlinkTextViewViewModel(
            text: "Med å gjøre en forespørsel aksepterer du også vilkårene for fiks, ferdig frakt og betaling.",
            hyperlinks: [
                HyperlinkTextViewViewModel.Hyperlink(
                    hyperlink: "en forespørsel",
                    action: "test://foobar"
                ),
                HyperlinkTextViewViewModel.Hyperlink(
                    hyperlink: "vilkårene for fiks, ferdig frakt og betaling",
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

extension TextViewDemoView: HyperlinkTextViewViewModelDelegate {
    public func didTapHyperlinkAction(_ action: String) {
        print("Action \(action) was tapped.")
    }
}

// MARK: - TextViewDelegate

extension TextViewDemoView: TextViewDelegate {
    public func textViewDidChange(_ textView: TextView) {
    }

    public func textViewShouldBeginEditing(_ textView: TextView) -> Bool {
        true
    }

    public func textViewDidBeginEditing(_ textView: TextView) {
    }

    public func textViewDidEndEditing(_ textView: TextView) {
    }

    public func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }
}
