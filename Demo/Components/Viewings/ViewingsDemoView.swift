//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ViewingsDemoView: UIView {

    private lazy var viewingsView = ViewingsView(frame: .zero)

    private let viewModel = ViewingsViewModel(
        title: "Visninger",
        addToCalendarButtonTitle: "Legg til i kalender",
        viewings: [ViewingCellViewModel(weekday: "Søndag", month: "JAN", date: "19", timeInterval: "Kl. 12.00 - 13.00"),
                   ViewingCellViewModel(weekday: "Mandag", month: "JAN", date: "20", timeInterval: "Kl. 18.30 - 19.30")
        ],
        note: "Velkommen til visning!"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        viewingsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(viewingsView)
        viewingsView.configure(with: viewModel)

        NSLayoutConstraint.activate([
            viewingsView.widthAnchor.constraint(equalTo: widthAnchor),
            viewingsView.heightAnchor.constraint(equalToConstant: viewingsView.heightNeeded(forWidth: viewingsView.frame.size.width)),
            viewingsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewingsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
