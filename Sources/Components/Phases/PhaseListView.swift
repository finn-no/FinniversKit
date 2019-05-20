//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class PhaseListView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .smallSpacing
        return stackView
    }()

    private lazy var connectorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModels: [PhaseViewModel]) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }

        for viewModel in viewModels {
            let phaseView = PhaseView()
            phaseView.configure(with: viewModel)
            stackView.addArrangedSubview(phaseView)
        }
    }

    private func setup() {
        backgroundColor = .ice

        addSubview(connectorView)
        addSubview(stackView)

        let insets = UIEdgeInsets(
            top: .mediumLargeSpacing,
            leading: .mediumLargeSpacing,
            bottom: -.mediumLargeSpacing,
            trailing: -.mediumLargeSpacing
        )

        stackView.fillInSuperview(insets: insets)

        NSLayoutConstraint.activate([
            connectorView.topAnchor.constraint(equalTo: topAnchor),
            connectorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            connectorView.centerXAnchor.constraint(equalTo: stackView.leadingAnchor, constant: PhaseView.dotCenterX),
            connectorView.widthAnchor.constraint(equalToConstant: 2)
        ])
    }
}
