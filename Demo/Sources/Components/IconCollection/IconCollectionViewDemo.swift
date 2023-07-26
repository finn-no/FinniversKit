//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class IconCollectionDemoView: UIView {

    // MARK: - Private properties

    private var collectionView: IconCollectionView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)
        backgroundColor = .bgPrimary
    }

    // MARK: - Private methods

    private func setupIconCollectionView(withAlignment alignment: IconCollectionView.Alignment) {
        collectionView?.removeFromSuperview()

        let collectionView = IconCollectionView(alignment: alignment)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingS),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingS)
        ])

        switch alignment {
        case .horizontal:
            collectionView.configure(with: .horizontalModels)
            collectionView.backgroundColor = .bgSecondary
            collectionView.layer.cornerRadius = 8
            collectionView.clipsToBounds = true
            collectionView.tintColor = .textPrimary

        case .vertical:
            collectionView.configure(with: .verticalModels)
            collectionView.backgroundColor = .bgPrimary
            collectionView.layer.cornerRadius = 0
            collectionView.clipsToBounds = false
        }

        self.collectionView = collectionView
    }
}

extension IconCollectionDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, DemoKit.TweakingOption {
        case verticalAlignment
        case horizontalAlignment
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any DemoKit.TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .verticalAlignment:
            setupIconCollectionView(withAlignment: .vertical)
        case .horizontalAlignment:
            setupIconCollectionView(withAlignment: .horizontal)
        }
    }
}

// MARK: - Private extensions

private extension Array where Element == IconCollectionViewModel {
    static var horizontalModels: [IconCollectionViewModel] {
        [
            IconCollectionViewModel(title: "Modellår", text: "2006", image: UIImage(named: .iconRealestateBedrooms).withRenderingMode(.alwaysTemplate)),
            IconCollectionViewModel(title: "Kilometer", text: "309 000", image: UIImage(named: .iconRealestateApartments).withRenderingMode(.alwaysTemplate)),
            IconCollectionViewModel(title: "Girkasse", text: "Manuell", image: UIImage(named: .iconRealestatePrice).withRenderingMode(.alwaysTemplate)),
            IconCollectionViewModel(title: "Drivstoff", text: "Diesel", image: UIImage(named: .iconRealestateOwner).withRenderingMode(.alwaysTemplate))
        ]
    }

    static var verticalModels: [IconCollectionViewModel] {
        [
            IconCollectionViewModel(text: "0-2 soverom", image: UIImage(named: .iconRealestateBedrooms)),
            IconCollectionViewModel(text: "Leilighet, Enebolig, Rekkehus", image: UIImage(named: .iconRealestateApartments)),
            IconCollectionViewModel(text: "Pris kommer", image: UIImage(named: .iconRealestatePrice)),
            IconCollectionViewModel(text: "Eier (Selveier)", image: UIImage(named: .iconRealestateOwner))
        ]
    }
}
