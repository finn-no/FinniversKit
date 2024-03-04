//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class EmptyViewDemoView: UIView {
    var emptyView: EmptyView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setupEmptyView(header: String, message: String, image: UIImage? = nil, actionButtonTitle: String = "") {
        self.emptyView?.removeFromSuperview()
        self.emptyView = nil
        self.emptyView = EmptyView()
        self.addSubview(self.emptyView!) // swiftlint:disable:this force_unwrapping
        self.emptyView?.fillInSuperview()

        self.emptyView?.header = header
        self.emptyView?.message = message
        self.emptyView?.image = image
        self.emptyView?.actionButtonTitle = actionButtonTitle
    }
}

extension EmptyViewDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case actionButtonEmptyView
        case imageEmptyView
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .actionButtonEmptyView:
            setupEmptyView(
                header: "Her var det stille gitt",
                message: "Når du prater med andre på FINN, vil meldingene dine dukke opp her.\n\n Søk på noe du har lyst på, send en melding til selgeren og bli enige om en handel på én-to-tre!",
                actionButtonTitle: "Gjør et søk"
            )
        case .imageEmptyView:
            setupEmptyView(
                header: "Vi gir deg beskjed når det kommer noe nytt!",
                message: "Søk på noe du har lyst på og trykk “Lagre søk”. Da varsler FINN deg når det dukker opp nye annonser.\n\nSmart hva?",
                image: UIImage(named: .emptyStateSaveSearch)
            )
        }
    }
}
