//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class PanelDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = .mediumLargeSpacing
        addSubview(stackView)
        stackView.fillInSuperview(margin: .mediumSpacing)

        let demoCases: [(Panel.Style, PanelViewModel)] = [
            (.plain, PanelViewModel(text: "Plain panel. Are you sure a normal Label isn't a better fit?")),
            (.info, PanelViewModel(text: "Info panel. Use info when you have information that should be highligtet, grouped or separated slightly from the content.")),
            (.info, PanelViewModel(cornerRadius: 16, text: "Info panel with custom (16) corners. Custom corners should normally not be used.")),
            (.tips, PanelViewModel(text: "Tip panel. Tips is information we want to emphasize to the user. This box has to stand out more than the info box.")),
            (.newFunctionality, PanelViewModel(text: "New functionality panel. If we release new functionality, it may need a little extra attention.")),
            (.success, PanelViewModel(text: "Success panel. When the action was a success. It differs from the design of the \"new functionality\" in that it does not have the frame.")),
            (.warning, PanelViewModel(text: "Warning panel. If there is something we want make user aware of, something is on hold, or something may affect the flow. Broadcasts are an example.")),
            (.error, PanelViewModel(text: "Error panel. When things go wrong, or something happens that have a negative impact for the user.")),
        ]

        demoCases.forEach {
            let panel = Panel(style: $0.0)
            panel.translatesAutoresizingMaskIntoConstraints = false
            panel.configure(with: $0.1)
            stackView.addArrangedSubview(panel)
        }
        let fillerView = UIView(withAutoLayout: true)
        fillerView.setContentHuggingPriority(UILayoutPriority(0), for: .vertical)
        stackView.addArrangedSubview(fillerView)
    }
}
