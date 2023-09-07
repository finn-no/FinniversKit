//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

public class PhaseListDemoView: UIView, Demoable {
    private lazy var phaseListView = PhaseListView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(phaseListView)

        phaseListView.configure(with: [
            PhaseViewModel(title: "Planlegging", detailText: "Venter på godkjenning", isHighlighted: true),
            PhaseViewModel(title: "Salgsstart", detailText: "Slutten av april 2019", isHighlighted: false),
            PhaseViewModel(title: "Byggestart", detailText: "Estimert årsskifte 2019/2020", isHighlighted: false),
            PhaseViewModel(title: "Innflytting", detailText: "Planlagt Q2 2022", isHighlighted: false)
        ])

        NSLayoutConstraint.activate([
            phaseListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            phaseListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            phaseListView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
