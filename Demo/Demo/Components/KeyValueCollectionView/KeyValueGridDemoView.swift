//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class KeyValueGridDemoView: UIView {
    private lazy var keyValueGridView: KeyValueGridView = {
        let view = KeyValueGridView(withAutoLayout: true)
        view.configure(with: sampleData)
        view.backgroundColor = .bgSecondary
        view.numberOfColumns = numberOfColumnsForTraits
        return view
    }()

    private lazy var scrollView = UIScrollView(withAutoLayout: true)

    let sampleData = [
        KeyValuePair(title: "Omregistrering", value: "1 618 kr"),
        KeyValuePair(title: "Pris eks omreg", value: "178 381 kr"),
        KeyValuePair(title: "Årsavgift", value: "Nye regler."),
        KeyValuePair(title: "1. gang registrert", value: "30.09.2009"),
        KeyValuePair(title: "Farge", value: "Svart"),
        KeyValuePair(title: "Fargebeskrivelse", value: "Black Pearl Magic"),
        KeyValuePair(title: "Interiørfarge", value: "Grå"),
        KeyValuePair(title: "Hjuldrift", value: "Firehjulsdrift"),
        KeyValuePair(title: "Hjuldriftnavn", value: "4MOTION"),
        KeyValuePair(title: "Effekt", value: "174 Hk"),
        KeyValuePair(title: "Sylindervolum", value: "2,5 l"),
        KeyValuePair(title: "Vekt", value: "2 005 kg"),
        KeyValuePair(title: "CO2-utslipp", value: "254 g/km"),
        KeyValuePair(title: "Antall seter", value: "7"),
        KeyValuePair(title: "Karosseri", value: "Kasse"),
        KeyValuePair(title: "Antall dører", value: "4"),
        KeyValuePair(title: "Antall eiere", value: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc placerat, elit porta dictum semper, dui purus tincidunt metus, vel hendrerit lectus est at erat. Cras fringilla nisl et ipsum aliquam auctor. Aenean scelerisque lacinia ultrices. Aenean ante velit, tempus ac lacinia ut, laoreet sed dolor. Donec scelerisque erat ut enim dictum interdum. Phasellus condimentum, sapien id convallis elementum, nunc felis auctor lectus, in rutrum nisi massa molestie arcu. Mauris pellentesque egestas hendrerit. Maecenas interdum, erat in vehicula volutpat, leo nulla imperdiet turpis, at dapibus augue purus ut mauris. In varius tortor eget eros ultricies sagittis. Aenean aliquam, justo vel interdum condimentum, diam massa accumsan metus, non consequat nisl odio id lacus. Duis vehicula vulputate euismod."),
        KeyValuePair(title: "Bilen står i", value: "Norge"),
        KeyValuePair(title: "Salgsform", value: "Bruktbil til salgs"),
        KeyValuePair(title: "Avgiftsklasse", value: "Personbil"),
        KeyValuePair(title: "Reg.nr", value: "DX11111"),
        KeyValuePair(title: "Chassis nr. (VIN)", value: "XX1234XX1X099999"),
        KeyValuePair(title: "Maksimal tilhengervekt", value: "2 500 kg"),
    ]

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
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
