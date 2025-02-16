//
//  Copyright © 2020 FINN AS. All rights reserved.
//
import FinniversKit
import Warp
import SwiftUI
import DemoKit

class KeyValueGridDemoView: UIView {

    // Create a UIHostingController that hosts your SwiftUI grid view.
    private lazy var hostingController: UIHostingController<KeyValueGridView> = {
        let swiftUIView = KeyValueGridView(
            keyValuePairs: .demoData,
            numberOfColumns: numberOfColumnsForTraits,
            titleFont: .body,
            valueFont: .body
        )
        let controller = UIHostingController(rootView: swiftUIView)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        // Optionally set a background color if needed.
        controller.view.backgroundColor = .clear
        return controller
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private methods

    private func setup() {
        directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: Warp.Spacing.spacing400,
            leading: Warp.Spacing.spacing400,
            bottom: Warp.Spacing.spacing400,
            trailing: Warp.Spacing.spacing400
        )
        addSubview(scrollView)
        scrollView.fillInSuperviewLayoutMargins()

        // Add the hosting controller's view to the scroll view.
        scrollView.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor)
        ])
    }

    /// Determines the number of columns based on the current horizontal size class.
    private var numberOfColumnsForTraits: Int {
        traitCollection.horizontalSizeClass == .compact ? 2 : 3
    }

    /// When traits change, update the SwiftUI view with the new number of columns.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection != traitCollection else { return }
        let currentPairs = hostingController.rootView.keyValuePairs
        hostingController.rootView = KeyValueGridView(
            keyValuePairs: currentPairs,
            numberOfColumns: numberOfColumnsForTraits,
            titleFont: hostingController.rootView.titleFont,
            valueFont: hostingController.rootView.valueFont
        )
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
//        switch Tweaks.allCases[index] {
//        case .default:
//            hostingController.rootView = KeyValueGridView(
//                keyValuePairs: .demoData,
//                numberOfColumns: numberOfColumnsForTraits,
//                titleFont: .body,
//                valueFont: .body
//            )
//            hostingController.view.backgroundColor = .backgroundInfoSubtle
//        case .energyLabels:
//            hostingController.rootView = KeyValueGridView(
//                keyValuePairs: .energyLabels,
//                numberOfColumns: numberOfColumnsForTraits,
//                titleFont: .body,
//                valueFont: .body
//            )
//            hostingController.view.backgroundColor = .background
//        }
    }
}


// MARK: - Private extensions

private extension Array where Element == KeyValuePair {
    static var demoData: [KeyValuePair] = [
        .init(title: "Driving range", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions"),
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
        .init(title: "Driving range", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions"),
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
        .init(title: "Driving range WLTP", value: "409 km", infoTooltip: "WLTP is a metric from when the car was new and the actual range must be seen in context of age, km, driving pattern and weather conditions"),
    ]

    static var energyLabels: [KeyValuePair] = [
        .init(
            title: "Energimerking",
            value: "Mørkegrønn",
            valueStyle: .init(
                textColor: UIColor(hex: "#ffffff"),
                backgroundColor: UIColor(hex: "#277457"),
                horizontalPadding: Warp.Spacing.spacing50
            )
        ),
        .init(
            title: "Energimerking",
            value: "Lysegrønn",
            valueStyle: .init(
                textColor: UIColor(hex: "#474445"),
                backgroundColor: UIColor(hex: "#68e2b8"),
                horizontalPadding: Warp.Spacing.spacing50
            )
        ),
        .init(
            title: "Energimerking",
            value: "Gul",
            valueStyle: .init(
                textColor: UIColor(hex: "#474445"),
                backgroundColor: UIColor(hex: "#fff5c8"),
                horizontalPadding: Warp.Spacing.spacing50
            )
        ),
        .init(
            title: "Energimerking",
            value: "Oransje",
            valueStyle: .init(
                textColor: UIColor(hex: "#000000"),
                backgroundColor: UIColor(hex: "#ff5844"),
                horizontalPadding: Warp.Spacing.spacing50
            )
        ),
        .init(
            title: "Energimerking",
            value: "Rød",
            valueStyle: .init(
                textColor: UIColor(hex: "#ffffff"),
                backgroundColor: UIColor(hex: "#da2400"),
                horizontalPadding: Warp.Spacing.spacing50
            )
        )
    ]
}
