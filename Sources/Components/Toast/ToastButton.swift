//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

internal class ToastButton: UIButton {

    // MARK: - Private properties

    private let toastStyle: ToastView.Style
    private let buttonStyle: ToastView.ButtonStyle

    // MARK: - Init

    init(toastStyle: ToastView.Style, buttonStyle: ToastView.ButtonStyle) {
        self.toastStyle = toastStyle
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel?.font = .bodyStrong
        layer.masksToBounds = true
        setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .horizontal)

        switch buttonStyle {
        case .normal:
            setTitleColor(.btnPrimary, for: .normal)
        case .promoted:
            setTitleColor(.licorice, for: .normal)
            contentEdgeInsets = UIEdgeInsets(vertical: .mediumSpacing, horizontal: .mediumLargeSpacing)
            layer.borderColor = .bgPrimary
            layer.borderWidth = 2
        }

        switch (toastStyle, buttonStyle) {
        case (.errorButton, .promoted):
            backgroundColor = .watermelon
        case (.successButton, .promoted):
            backgroundColor = .pea
        default: break
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
