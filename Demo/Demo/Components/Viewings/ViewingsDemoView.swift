//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ViewingsDemoView: UIView {

    private lazy var viewingsView = ViewingsView(withAutoLayout: true)

    private let viewModel = ViewingsViewModel(
        title: "Visninger",
        addToCalendarButtonTitle: "Legg til i kalender",
        viewings: [ViewingCellViewModel(weekday: "Søndag", month: "JAN", day: "19", timeInterval: "Kl. 12.00 - 13.00", note: "Visningen streames"),
                   ViewingCellViewModel(weekday: "Mandag", month: "JAN", day: "20", timeInterval: "Kl. 18.30 - 19.30", note: nil)
        ],
        note: "Velkommen til visning!"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(viewingsView)
        viewingsView.configure(with: viewModel)

        NSLayoutConstraint.activate([
            viewingsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            viewingsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            viewingsView.heightAnchor.constraint(equalToConstant: viewingsView.heightNeeded(forWidth: viewingsView.frame.size.width)),
            viewingsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewingsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
