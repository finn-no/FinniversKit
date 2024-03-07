//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import DemoKit

class TextViewDemoView: UIView {

    // MARK: - Private properties

    private lazy var textView = TextView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        textView.delegate = self
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            textView.bottomAnchor.constraint(equalTo: centerYAnchor)
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

    // MARK: - Actions

    @objc private func handleTap() {
        endEditing(true)
    }
}

// MARK: - TextViewDelegate

extension TextViewDemoView: TextViewDelegate {
    func textViewDidChange(_ textView: TextView) {
    }

    func textViewShouldBeginEditing(_ textView: TextView) -> Bool {
        true
    }

    func textViewDidBeginEditing(_ textView: TextView) {
    }

    func textViewDidEndEditing(_ textView: TextView) {
    }

    func textView(_ textView: TextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        true
    }
}

extension TextViewDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case scrollable
        case nonScrollable
        case underlineHidden
        case otherBackgroundColor
        case otherBackgroundColorAndUnderlineHidden
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .scrollable:
            configure(placeholderText: "Scrollable TextView")
        case .nonScrollable:
            configure(placeholderText: "Non-scrollable TextView", isScrollable: false)
        case .underlineHidden:
            configure(placeholderText: "Placeholder", hideUnderLine: true)
        case .otherBackgroundColor:
            configure(placeholderText: "Placeholder", backgroundColor: .backgroundSubtle)
        case .otherBackgroundColorAndUnderlineHidden:
            configure(placeholderText: "Placeholder", hideUnderLine: true, backgroundColor: .backgroundSubtle)
        }
    }
}
