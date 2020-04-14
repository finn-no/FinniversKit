//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ButtonDemoView: UIView {
    // Relevant Styles, States and Sizes to show for the demo
    let styles: [Button.Style] = [
        .callToAction,
        .default,
        .flat,
        .link,
        .destructive,
        .destructiveFlat,
        .utility,
    ]
    let states: [UIControl.State] = [.normal, .disabled]
    let sizes: [Button.Size] = [.normal, .small]

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInset = UIEdgeInsets(vertical: .spacingM, horizontal: .spacingL)

        let verticalStack = self.verticalStack()
        verticalStack.spacing = .spacingM

        styles.forEach { style in
            let buttonStyleStack = self.verticalStack()
            buttonStyleStack.spacing = .spacingS

            let titleLabel = Label(style: .title3, withAutoLayout: true)
            titleLabel.text = sectionTitle(for: style)
            buttonStyleStack.addArrangedSubview(titleLabel)

            sizes.forEach { size in
                let stateStack = UIStackView(withAutoLayout: true)
                stateStack.axis = .horizontal
                stateStack.spacing = .spacingS
                stateStack.distribution = .fillEqually

                states.forEach { state in
                    let title = self.title(for: size, state: state)

                    let button = Button(style: style, size: size, withAutoLayout: true)
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

    private func verticalStack() -> UIStackView {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }

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

    private func sectionTitle(for style: Button.Style) -> String {
        switch style {
        case .callToAction: return "Call to Action"
        case .default: return "Default"
        case .flat: return "Flat"
        case .link: return "Link"
        case .destructive: return "Destructive"
        case .destructiveFlat: return "Destructive Flat"
        case .utility: return "Utility"
        default:
            return "Unknown"
        }
    }
}
