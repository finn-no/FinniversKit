//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

class ColumnListsDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private lazy var columnListsView: ColumnListsView = {
        let view = ColumnListsView(withAutoLayout: true)
        view.backgroundColor = .bgTertiary
        return view
    }()

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass else {
            return
        }

        columnListsView.numberOfColumns = numberOfColumnsForTraits()
    }

    func numberOfColumnsForTraits() -> Int {
        if case .compact = traitCollection.horizontalSizeClass {
            return 2
        } else {
            return 3
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        columnListsView.numberOfColumns = numberOfColumnsForTraits()
    }

    private let sampleData = [
        "ABS-bremser",
        "Antispinn",
        "Antiskrens",
        "AUX-inngang",
        "Air Condition",
        "Bagasjeromstrekk",
        "Bluetooth",
        "CD-spiller",
        "El. speil",
        "El. vinduer",
        "El. sete",
        "Lett. felg vinter",
        "Lett. felg sommer",
        "Lyssensor",
        "Klimaanlegg",
        "Kjørecomputer",
        "Metallic",
        "Midtarmlene",
        "Multifunksjonsratt",
        "Mørke vinder",
        "Navigasjonssystem",
        "Nivåregulering",
        "Nøkkelløs start",
        "Park.sensor bak",
        "Parkeringssensor foran og bak og midt i mellom",
        "Radio DAB+",
        "Radio FM",
        "Regnsensor",
        "Ryggekamera",
        "Sentrallås",
        "Servostyring",
        "Seter (Skinn)",
        "Sportsseter",
        "Startsperre",
        "Sideairbager",
        "Sommerhjul",
        "Soltak (Glass)",
        "Takrails",
        "Xenonlys",
    ]

    private func setup() {
        addSubview(columnListsView)

        columnListsView.configure(with: sampleData, numberOfColumns: numberOfColumnsForTraits(), style: .caption)
        NSLayoutConstraint.activate([
            columnListsView.centerYAnchor.constraint(equalTo: centerYAnchor),
            columnListsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            columnListsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}
