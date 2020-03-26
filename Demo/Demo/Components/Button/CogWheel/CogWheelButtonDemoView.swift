//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CogWheelButtonDemoView: UIView {

    private lazy var leftCogWheelButton = CogWheelButton(alignment: .left, autoLayout: true)
    private lazy var rightCogWheelButton = CogWheelButton(alignment: .right, autoLayout: true)

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [leftCogWheelButton, rightCogWheelButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()

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
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
