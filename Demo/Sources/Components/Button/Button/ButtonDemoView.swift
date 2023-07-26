//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import DemoKit

public class ButtonDemoView: UIView, Demoable {
    let states: [UIControl.State] = [.normal, .disabled]
    let sizes: [Button.Size] = [.normal, .small]

    // Relevant Styles, States and Sizes to show for the demo
    let styles: [(style: Button.Style, title: String)] = [
        (style: .callToAction, title: "Call to Action"),
        (style: .default, title: "Default"),
        (style: .flat, title: "Flat"),
        (style: .link, title: "Link"),
        (style: .destructive, title: "Destructive"),
        (style: .destructiveFlat, title: "Destructive Flat"),
        (style: .utility, title: "Utility"),
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInset = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingL)

        let verticalStack = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

        styles.forEach { styleTuple in
            let buttonStyleStack = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

            let titleLabel = Label(style: .title3, withAutoLayout: true)
            titleLabel.text = styleTuple.title
            buttonStyleStack.addArrangedSubview(titleLabel)

            sizes.forEach { size in
                let stateStack = UIStackView(withAutoLayout: true)
                stateStack.axis = .horizontal
                stateStack.spacing = .spacingS
                stateStack.distribution = .fillEqually

                states.forEach { state in
                    let title = title(for: size, state: state)

                    let button = Button(style: styleTuple.style, size: size, withAutoLayout: true)
                    button.setTitle(title, for: state)
                    button.isEnabled = state != .disabled

                    stateStack.addArrangedSubview(button)
                }

                buttonStyleStack.addArrangedSubview(stateStack)
            }

            verticalStack.addArrangedSubview(buttonStyleStack)
        }

        scrollView.addSubview(verticalStack)
        addSubview(scrollView)

        scrollView.fillInSuperview()
        verticalStack.fillInSuperview()
        NSLayoutConstraint.activate([
            verticalStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: -.spacingL * 2)
        ])
    }

    // MARK: - Private methods

    private func title(for size: Button.Size, state: UIControl.State) -> String {
        stateName(state: state) + " " + sizeName(size: size)
    }

    private func sizeName(size: Button.Size) -> String {
        switch size {
        case .normal: return ""
        case .small: return "Small"
        }
    }

    private func stateName(state: UIControl.State) -> String {
        switch state {
        case .normal: return "Normal"
        case .disabled: return "Disabled"
        case .highlighted: return "Highlghted"
        default: return "?"
        }
    }
}
