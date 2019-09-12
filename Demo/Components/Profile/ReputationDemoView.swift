//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class ReputationDemoView: UIView {

    // MARK: - Setup

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        var views = [
            headerLabel(withText: "Compact"),
            summaryView(breakdownMode: .compact),
            headerLabel(withText: "Collapsed by Default"),
            summaryView(breakdownMode: .collapsedByDefault),
            headerLabel(withText: "Always Expanded"),
            summaryView(breakdownMode: .alwaysExpanded),
        ]

        var anchor = topAnchor
        views.forEach {
            addView($0, below: anchor)
            anchor = $0.bottomAnchor
        }
    }

    private func summaryView(breakdownMode: ReputationBreakdownMode) -> ReputationView {
        let viewModel = ViewModel(breakdownMode: breakdownMode)
        let view = ReputationView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    private func headerLabel(withText text: String) -> Label {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }

    private func addView(_ view: UIView, below anchor: NSLayoutYAxisAnchor) {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            view.topAnchor.constraint(equalTo: anchor, constant: .mediumSpacing),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing)
        ])
    }
}

fileprivate struct ViewModel: ReputationViewModel {
    let title: String = "Veldig bra"
    let subtitle: String = "22 vurderinger"
    let score: Float = 0.843419429
    let categoryBreakdowns: [ReputationBreakdownModel] = [
        BreakdownModel(category: .communication, title: "Veldig bra kommunikasjon"),
        BreakdownModel(category: .transaction, title: "Problemfri overlevering"),
        BreakdownModel(category: .description, title: "Nøyaktig beskrivelse"),
        BreakdownModel(category: .payment, title: "Problemfri betaling")
    ]

    let breakdownMode: ReputationBreakdownMode
}

fileprivate struct BreakdownModel: ReputationBreakdownModel {
    let category: ReputationBreakdownCategory
    let title: String
}
