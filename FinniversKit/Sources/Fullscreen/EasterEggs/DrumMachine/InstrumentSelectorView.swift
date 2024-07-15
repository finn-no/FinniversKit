//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit
import Warp

protocol InstrumentSelectorViewDelegate: AnyObject {
    func instrumentSelectorView(_ view: InstrumentSelectorView, didSelectInstrument instrument: Instrument)
}

final class InstrumentSelectorView: UIView {
    weak var delegate: InstrumentSelectorViewDelegate?
    private var selectedInstrument: Instrument
    private var instruments: [Instrument] = [.kick, .snare, .hats, .cat]

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .textInverted
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: self.instruments.map({ $0.rawValue }))
        control.translatesAutoresizingMaskIntoConstraints = false

        control.selectedSegmentTintColor = .backgroundSubtle
        control.backgroundColor = .backgroundInfoSubtle
        return control
    }()

    // MARK: - Init

    init(instrument: Instrument) {
        selectedInstrument = instrument
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setup() {
        backgroundColor = .black
        addSubview(titleLabel)
        addSubview(segmentedControl)

        titleLabel.text = "Trommemaskin"
        segmentedControl.selectedSegmentIndex = instruments.firstIndex(where: { $0 == selectedInstrument }) ?? 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlChange(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing200),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            segmentedControl.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])
    }

    // MARK: - Actions

    @objc private func handleSegmentedControlChange(_ sender: UISegmentedControl) {
        selectedInstrument = instruments[sender.selectedSegmentIndex]
        delegate?.instrumentSelectorView(self, didSelectInstrument: selectedInstrument)
    }
}
