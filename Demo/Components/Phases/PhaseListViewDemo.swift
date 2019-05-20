//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class PhaseListDemoView: UIView {
    private lazy var phaseListView = PhaseListView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        phaseListView.configure(with: [
            PhaseViewModel(title: "Planlegging", detailText: "Venter på godkjenning", isHighlighted: true),
            PhaseViewModel(title: "Salgsstart", detailText: "Slutten av april 2019", isHighlighted: false),
            PhaseViewModel(title: "Byggestart", detailText: "Estimert årsskifte 2019/2020", isHighlighted: false),
            PhaseViewModel(title: "Innflytting", detailText: "Planlagt Q2 2022", isHighlighted: false)
        ])
    }

    // MARK: - Setup

    private func setup() {
        addSubview(phaseListView)

        NSLayoutConstraint.activate([
            phaseListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            phaseListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            phaseListView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
