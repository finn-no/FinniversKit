import UIKit
import FinniversKit
import DemoKit
import Warp

class MultilineButtonDemoView: UIView, Demoable {
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

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInset = UIEdgeInsets(vertical: Warp.Spacing.spacing200, horizontal: Warp.Spacing.spacing300)

        let verticalStack = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing200, withAutoLayout: true)

        styles.forEach { styleTuple in
            let buttonStyleStack = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, withAutoLayout: true)

            let titleLabel = Label(style: .title3, withAutoLayout: true)
            titleLabel.text = styleTuple.title
            buttonStyleStack.addArrangedSubview(titleLabel)

            sizes.forEach { size in
                let stateStack = UIStackView(withAutoLayout: true)
                stateStack.axis = .horizontal
                stateStack.spacing = Warp.Spacing.spacing100
                stateStack.distribution = .fillEqually

                states.forEach { state in
                    let title = "Lorem ipsum\ndolor sit amet"

                    let button = MultilineButton(style: styleTuple.style, size: size, withAutoLayout: true)
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
            verticalStack.widthAnchor.constraint(equalTo: widthAnchor, constant: -Warp.Spacing.spacing300 * 2)
        ])
    }

    // MARK: - Private methods

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
