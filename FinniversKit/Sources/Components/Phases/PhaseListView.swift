//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

public final class PhaseListView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = 14
        return stackView
    }()

    private var lineView: UIView?

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
        lineView?.removeFromSuperview()

        var phaseViews = [PhaseView]()

        for viewModel in viewModels {
            let phaseView = PhaseView()
            phaseView.configure(with: viewModel)

            stackView.addArrangedSubview(phaseView)
            phaseViews.append(phaseView)
        }

        if let firstPhaseView = phaseViews.first, let lastPhaseView = phaseViews.last {
            addLineView(from: firstPhaseView.dotView, to: lastPhaseView.dotView)
        }
    }

    private func setup() {
        backgroundColor = .backgroundInfoSubtle
        layer.cornerRadius = .spacingS

        addSubview(stackView)

        let insets = UIEdgeInsets(
            top: Warp.Spacing.spacing200,
            leading: Warp.Spacing.spacing200,
            bottom: -Warp.Spacing.spacing200,
            trailing: -Warp.Spacing.spacing200
        )

        stackView.fillInSuperview(insets: insets)
    }

    private func addLineView(from viewA: UIView, to viewB: UIView) {
        let lineView = UIView(withAutoLayout: true)
        lineView.backgroundColor = .border
        insertSubview(lineView, belowSubview: stackView)

        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: viewA.bottomAnchor),
            lineView.bottomAnchor.constraint(equalTo: viewB.topAnchor),
            lineView.centerXAnchor.constraint(equalTo: viewA.centerXAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 2)
        ])

        self.lineView = lineView
    }
}
