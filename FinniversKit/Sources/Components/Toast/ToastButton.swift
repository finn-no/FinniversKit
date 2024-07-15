//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

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
            setTitleColor(.textLink, for: .normal)
        case .promoted:
            setTitleColor(.textInverted, for: .normal)
            contentEdgeInsets = UIEdgeInsets(vertical: Warp.Spacing.spacing100, horizontal: Warp.Spacing.spacing200)
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 2
        }

        switch (toastStyle, buttonStyle) {
        case (.errorButton, .promoted):
            backgroundColor = .backgroundNegative
        case (.successButton, .promoted):
            backgroundColor = .backgroundPositive
        default: break
        }
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
