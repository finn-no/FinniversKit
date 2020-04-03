//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

public class ChatAvailabilityDemoView: UIView {

    let statuses = ChatAvailabilityView.Status.allCases

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingS
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        statuses.forEach { status in
            let view = ChatAvailabilityView(withAutoLayout: true)
            view.configure(status: status)
            stackView.addArrangedSubview(view)
        }

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
