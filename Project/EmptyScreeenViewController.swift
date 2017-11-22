//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class EmptyScreenViewController: UIViewController {

    // MARK: - Internal properties

    private lazy var emptyView: EmptyScreen = {
        let view = EmptyScreen()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.header = "Her var det stille gitt"
        view.message = "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!"
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .milk

        view.addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
