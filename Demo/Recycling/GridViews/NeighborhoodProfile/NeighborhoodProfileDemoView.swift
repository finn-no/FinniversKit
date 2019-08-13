//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class NeighborhoodProfileDemoView: UIView {
    private lazy var view: NeighborhoodProfileView = {
        let view = NeighborhoodProfileView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: .demo)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - NeighborhoodProfileViewDelegate

extension NeighborhoodProfileDemoView: NeighborhoodProfileViewDelegate {
    func neighborhoodProfileViewDidScroll(_ view: NeighborhoodProfileView) {
        print("Start")
    }

    func neighborhoodProfileViewDidScrollToEnd(_ view: NeighborhoodProfileView) {
        print("End")
    }

    func neighborhoodProfileView(_ view: NeighborhoodProfileView, didSelectUrl url: URL?) {
        print("\(String(describing: url)) selected")
    }
}

// MARK: - Private

private extension NeighborhoodProfileViewModel {
    static var demo: NeighborhoodProfileViewModel {
        return NeighborhoodProfileViewModel(
            title: "Om nabolaget",
            readMoreLink: Link(title: "Utforsk", url: nil),
            cards: [
                Card.info(
                    content: Content(
                        title: "Gangavstand til offentlig transport",
                        link: Link(title: "Mer om transport", url: nil),
                        icon: UIImage(named: "npPublicTransport")
                    ),
                    rows: [
                        Row(title: "Buss", detailText: "9 min", icon: UIImage(named: "npWalk")),
                        Row(title: "Jernbanestasjon", detailText: "8 min", icon: UIImage(named: "npDrive"))
                    ]
                ),
                Card.info(
                    content: Content(
                        title: "Nabolaget er spesielt anbefalt for",
                        link: Link(title: "Hva mer mener de lokalkjente?", url: nil),
                        icon: UIImage(named: "npRecommended")
                    ),
                    rows: [
                        Row(title: "Familier med barn"),
                        Row(title: "Etablerere"),
                        Row(title: "Godt voksne"),
                        Row(title: "Eldre")
                    ]
                ),
                Card.info(
                    content: Content(
                        title: "Hva er beste transportalternativ til jobben min?",
                        link: Link(title: "Finn reisetider", url: nil),
                        icon: UIImage(named: "npStopwatch")
                    ),
                    rows: []
                ),
                Card.info(
                    content: Content(
                        title: "Gangavstand til skole",
                        link: Link(title: "Mer om skoler", url: nil),
                        icon: UIImage(named: "npSchool")
                    ),
                    rows: [
                        Row(title: "Ungdomsskole", detailText: "20 min", icon: UIImage(named: "npWalk")),
                        Row(title: "Barneskole", detailText: "21 min", icon: UIImage(named: "npWalk"))
                    ]
                ),
                Card.info(
                    content: Content(
                        title: "Nabolaget oppleves som veldig trygt",
                        link: Link(title: "Hva mer mener de lokalkjente?", url: nil),
                        icon: UIImage(named: "npSafeNeighborhood")
                    ),
                    rows: []
                ),
                Card.info(
                    content: Content(
                        title: "Kort gangavstand til butikk",
                        link: Link(title: "Mer om handel", url: nil),
                        icon: UIImage(named: "npStore")
                    ),
                    rows: [
                        Row(title: "Dagligvare", detailText: "9 min", icon: UIImage(named: "npWalk")),
                        Row(title: "Kjøpesenter", detailText: "7 min", icon: UIImage(named: "npDrive"))
                    ]
                ),
                Card.info(
                    content: Content(
                        title: "Sammenlign nabolaget med der du bor i dag?",
                        link: Link(title: "Gå til sammenligning", url: nil),
                        icon: UIImage(named: "npCompare")
                    ),
                    rows: []
                ),
                Card.button(
                    content: Content(
                        title: "Vil du se hele oversikten?",
                        link: Link(title: "Utforsk nabolaget", url: nil),
                        icon: UIImage(named: "npHouseWeather")
                    )
                ),
            ]
        )
    }
}
