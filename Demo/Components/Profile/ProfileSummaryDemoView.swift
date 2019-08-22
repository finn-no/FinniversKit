//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class ProfileSummaryDemoView: UIView {

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
            headerLabel(withText: "Collapsible Summary"),
            summaryView(collapsible: true),
            headerLabel(withText: "Uncollapsible Summary"),
            summaryView(collapsible: false),
        ]

        var anchor = topAnchor
        views.forEach {
            addView($0, below: anchor)
            anchor = $0.bottomAnchor
        }
    }

    private func summaryView(collapsible: Bool) -> ProfileSummaryView {
        let viewModel = ViewModel(collapseBreakdown: collapsible)
        let view = ProfileSummaryView(viewModel: viewModel)
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

fileprivate struct ViewModel: ProfileSummaryViewModel {
    let title: String = "Veldig bra"
    let subtitle: String = "22 vurderinger"
    let score: Float = 0.84
    let categoryBreakdowns: [ProfileSummaryBreakdownModel] = [
        BreakdownModel(icon: UIImage(named: .speechbubbleSmiley), title: "Veldig bra kommunikasjon"),
        BreakdownModel(icon: UIImage(named: .handshake), title: "Problemfri overlevering"),
        BreakdownModel(icon: UIImage(named: .document), title: "Nøyaktig beskrivelse"),
        BreakdownModel(icon: UIImage(named: .creditcard), title: "Problemfri betaling")
    ]

    let collapseBreakdown: Bool
}

fileprivate struct BreakdownModel: ProfileSummaryBreakdownModel {
    let icon: UIImage
    let title: String
}
