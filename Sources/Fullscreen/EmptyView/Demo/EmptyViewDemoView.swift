//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class EmptyViewDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let emptyView = EmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false

        emptyView.header = "Her var det stille gitt"
        emptyView.message = "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!"
        emptyView.actionButtonTitle = "Gjør et søk"

        addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
