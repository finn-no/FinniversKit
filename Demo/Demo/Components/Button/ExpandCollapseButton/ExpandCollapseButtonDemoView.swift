//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

public class ExpandCollapseButtonDemoView: UIView {

    private lazy var expandCollapseButton: ExpandCollapseButton = {
        let button = ExpandCollapseButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleExpandState), for: .touchUpInside)
        return button
    }()

    private var expanded: Bool = false

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(expandCollapseButton)

        NSLayoutConstraint.activate([
            expandCollapseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            expandCollapseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        expandCollapseButton.setExpanded(expanded, animated: false)
    }

    // MARK: - Actions

    @objc private func toggleExpandState() {
        expanded.toggle()
        expandCollapseButton.setExpanded(expanded, animated: true)
    }
}
