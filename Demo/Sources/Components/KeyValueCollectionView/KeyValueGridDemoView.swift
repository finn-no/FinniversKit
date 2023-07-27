//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class KeyValueGridDemoView: UIView {

    private lazy var keyValueGridView: KeyValueGridView = {
        let view = KeyValueGridView(withAutoLayout: true)
        view.numberOfColumns = numberOfColumnsForTraits
        return view
    }()

    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func setup() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(all: .spacingXL)
        addSubview(scrollView)

        scrollView.addSubview(keyValueGridView)
        scrollView.fillInSuperviewLayoutMargins()
        NSLayoutConstraint.activate([
            keyValueGridView.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor),
            keyValueGridView.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            keyValueGridView.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
        ])
    }

    private var numberOfColumnsForTraits: Int {
        if case .compact = traitCollection.horizontalSizeClass {
            return 2
        } else {
            return 3
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection != traitCollection else { return }
        keyValueGridView.numberOfColumns = numberOfColumnsForTraits
    }
}

extension KeyValueGridDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case `default`
        case energyLabels
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .default:
            keyValueGridView.configure(with: .demoData)
            keyValueGridView.backgroundColor = .bgSecondary
        case .energyLabels:
            keyValueGridView.configure(with: .energyLabels)
            keyValueGridView.backgroundColor = .bgPrimary
        }
    }
}

// MARK: - Private extensions

private extension Array where Element == KeyValuePair {
    static var demoData: [KeyValuePair] = [
        .init(title: "Omregistrering", value: "1 618 kr"),
        .init(title: "Pris eks omreg", value: "178 381 kr"),
        .init(title: "Årsavgift", value: "Nye regler."),
        .init(title: "1. gang registrert", value: "30.09.2009"),
        .init(title: "Farge", value: "Svart"),
        .init(title: "Fargebeskrivelse", value: "Black Pearl Magic"),
        .init(title: "Interiørfarge", value: "Grå"),
        .init(title: "Hjuldrift", value: "Firehjulsdrift"),
        .init(title: "Hjuldriftnavn", value: "4MOTION"),
        .init(title: "Effekt", value: "174 Hk"),
        .init(title: "Sylindervolum", value: "2,5 l"),
        .init(title: "Vekt", value: "2 005 kg"),
        .init(title: "CO2-utslipp", value: "254 g/km"),
        .init(title: "Antall seter", value: "7"),
        .init(title: "Karosseri", value: "Kasse"),
        .init(title: "Antall dører", value: "4"),
        .init(title: "Antall eiere", value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc placerat, elit porta dictum semper, dui purus tincidunt metus, vel hendrerit lectus est at erat. Cras fringilla nisl et ipsum aliquam auctor. Aenean scelerisque lacinia ultrices. Aenean ante velit, tempus ac lacinia ut, laoreet sed dolor. Donec scelerisque erat ut enim dictum interdum. Phasellus condimentum, sapien id convallis elementum, nunc felis auctor lectus, in rutrum nisi massa molestie arcu. Mauris pellentesque egestas hendrerit. Maecenas interdum, erat in vehicula volutpat, leo nulla imperdiet turpis, at dapibus augue purus ut mauris. In varius tortor eget eros ultricies sagittis. Aenean aliquam, justo vel interdum condimentum, diam massa accumsan metus, non consequat nisl odio id lacus. Duis vehicula vulputate euismod."),
        .init(title: "Bilen står i", value: "Norge"),
        .init(title: "Salgsform", value: "Bruktbil til salgs"),
        .init(title: "Avgiftsklasse", value: "Personbil"),
        .init(title: "Reg.nr", value: "DX11111"),
        .init(title: "Chassis nr. (VIN)", value: "XX1234XX1X099999"),
        .init(title: "Maksimal tilhengervekt", value: "2 500 kg"),
    ]

    static var energyLabels: [KeyValuePair] = [
        .init(
            title: "Energimerking",
            value: "Mørkegrønn",
            valueStyle: .init(
                textColor: UIColor(hex: "#ffffff"),
                backgroundColor: UIColor(hex: "#277457"),
                horizontalPadding: .spacingXS
            )
        ),
        .init(
            title: "Energimerking",
            value: "Lysegrønn",
            valueStyle: .init(
                textColor: UIColor(hex: "#474445"),
                backgroundColor: UIColor(hex: "#68e2b8"),
                horizontalPadding: .spacingXS
            )
        ),
        .init(
            title: "Energimerking",
            value: "Gul",
            valueStyle: .init(
                textColor: UIColor(hex: "#474445"),
                backgroundColor: UIColor(hex: "#fff5c8"),
                horizontalPadding: .spacingXS
            )
        ),
        .init(
            title: "Energimerking",
            value: "Oransje",
            valueStyle: .init(
                textColor: UIColor(hex: "#000000"),
                backgroundColor: UIColor(hex: "#ff5844"),
                horizontalPadding: .spacingXS
            )
        ),
        .init(
            title: "Energimerking",
            value: "Rød",
            valueStyle: .init(
                textColor: UIColor(hex: "#ffffff"),
                backgroundColor: UIColor(hex: "#da2400"),
                horizontalPadding: .spacingXS
            )
        )
    ]
}
