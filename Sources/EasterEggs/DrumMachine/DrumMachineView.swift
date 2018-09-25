//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class DrumMachineView: UIView {
    private let padSpacing: CGFloat = .largeSpacing
    private let cellSpacing: CGFloat = .mediumSpacing
    private let numberOfPads = 16
    private var currentPad = 0
    private var timer: Timer?
    private var beatsPerMinute: Float = 120

    private lazy var compositions: [Instrument: [Bool]] = self.makeEmptyCompositions()

    private var instrument: Instrument = .kick {
        didSet {
            collectionView.reloadData()
        }
    }

    private var timeInterval: Double {
        return (60.0 / Double(beatsPerMinute)) / 4
    }

    private lazy var selectorView: InstrumentSelectorView = {
        let selectorView = InstrumentSelectorView(instrument: self.instrument)
        selectorView.translatesAutoresizingMaskIntoConstraints = false
        return selectorView
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.register(DrumPadCollectionViewCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private lazy var collectionViewLayout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = cellSpacing
        layout.minimumLineSpacing = cellSpacing
        layout.sectionInset = UIEdgeInsets(top: padSpacing, left: padSpacing, bottom: padSpacing, right: padSpacing)
        return layout
    }()

    private lazy var bpmSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 80
        slider.maximumValue = 160
        slider.tintColor = .pea
        return slider
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    public func reset() {
        stop()
        currentPad = 0
        compositions = makeEmptyCompositions()
        collectionView.reloadData()
        start()
    }

    public func start() {
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }

    public func stop() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Timer

    @objc private func update() {
        currentPad += 1

        if currentPad == numberOfPads {
            currentPad = 0
        }

        let nextCell = collectionView.cellForItem(at: IndexPath(item: currentPad, section: 0)) as? DrumPadCollectionViewCell

        nextCell?.flash(withDuration: timeInterval)

        for (_, instrumentComposition) in compositions.enumerated() {
            if instrumentComposition.value[currentPad] {
                instrumentComposition.key.play()
            }
        }
    }

    private func makeEmptyCompositions() -> [Instrument: [Bool]] {
        return [
            .kick: Array(repeating: false, count: self.numberOfPads),
            .snare: Array(repeating: false, count: self.numberOfPads),
            .hats: Array(repeating: false, count: self.numberOfPads),
            .cat: Array(repeating: false, count: self.numberOfPads)
        ]
    }

    @objc private func sliderValueChanged(_ slider: UISlider) {
        beatsPerMinute = slider.value
        stop()
        start()
    }

    // MARK: - Setup

    private func setupSubviews() {
        backgroundColor = .black

        addSubview(selectorView)
        addSubview(collectionView)
        addSubview(bpmSlider)

        selectorView.delegate = self
        bpmSlider.setValue(beatsPerMinute, animated: false)
        bpmSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        collectionView.reloadData()
    }

    private func setupConstraints() {
        if #available(iOS 11.0, *) {
            selectorView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            selectorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            selectorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorView.heightAnchor.constraint(equalToConstant: 100),

            collectionView.topAnchor.constraint(equalTo: selectorView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bpmSlider.topAnchor),

            bpmSlider.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: .mediumLargeSpacing),
            bpmSlider.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor, constant: -.mediumLargeSpacing)
        ])

        if #available(iOS 11.0, *) {
            bpmSlider.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            bpmSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DrumMachineView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfPads
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DrumPadCollectionViewCell.self, for: indexPath)
        cell.contentView.backgroundColor = instrument.color
        cell.updateOverlayVisibility(isVisible: compositions[instrument]?[indexPath.item] ?? false)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension DrumMachineView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pad = indexPath.item
        let currentValue = compositions[instrument]?[pad] ?? false
        let newValue = !currentValue
        compositions[instrument]?[pad] = newValue

        let cell = collectionView.cellForItem(at: IndexPath(item: pad, section: 0)) as? DrumPadCollectionViewCell
        cell?.updateOverlayVisibility(isVisible: newValue)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = calculateItemMeasurement(for: collectionView.frame.width)
        return CGSize(width: size, height: size)
    }

    private func calculateItemMeasurement(for parentSideSize: CGFloat) -> CGFloat {
        let itemsPerRow: CGFloat = 4
        return (parentSideSize - cellSpacing * (itemsPerRow - 1) - padSpacing * 2) / itemsPerRow
    }
}

// MARK: - InstrumentSelectorViewDelegate

extension DrumMachineView: InstrumentSelectorViewDelegate {
    func instrumentSelectorView(_ view: InstrumentSelectorView, didSelectInstrument instrument: Instrument) {
        self.instrument = instrument
    }
}
