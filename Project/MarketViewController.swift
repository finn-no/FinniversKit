//
//  MarketViewController.swift
//  Project
//
//  Created by Dybdal, Aksel on 29.09.2017.
//  Copyright © 2017 FINN AS. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class MarketViewController: UIViewController {

    fileprivate lazy var discoverGridView: PreviewGridView = {
        let gridView = PreviewGridView(delegate: self, dataSource: self)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketGridCollectionView = {
        let marketGridView = MarketGridCollectionView(delegate: self)
        return marketGridView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.addSubview(discoverGridView)

        discoverGridView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        discoverGridView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        discoverGridView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        discoverGridView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

        marketGridView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250) // Initial size
        marketGridView.marketGridPresentables = marketItems()

        discoverGridView.previewPresentables = PreviewDataModelFactory.create(numberOfModels: 9)
        discoverGridView.headerView = marketGridView
    }

    private func marketItems() -> [MarketGridPresentable]  {
        // Demo code only
        struct MarketGridDataModel: MarketGridPresentable {
            let iconImage: UIImage?
            let showExternalLinkIcon: Bool
            let title: String
        }

        let images: [PlaygroundImage] = [.eiendom, .bil, .torget, .jobb, .mc, .bT, .nytte, .smajobb, .reise, .mittAnbud, .shopping, .moteplassen]
        let titles: [String] = ["Eiendom","Bil", "Torget", "Jobb", "MC", "Båt", "Nyttekjøretøy", "Småjobber", "Reise", "Oppdrag", "Shopping", "Møteplassen"]
        let shouldShowExternal: [Bool] = [false, false, false, false, false, false, false, true, true, true, true, true]

        return (0..<titles.count).flatMap { index in
            return MarketGridDataModel(iconImage: images[index].image, showExternalLinkIcon: shouldShowExternal[index], title: titles[index])
        }
    }
}

// MARK: - PreviewGridViewDelegate
extension MarketViewController: PreviewGridViewDelegate {

    func didSelect(item: PreviewPresentable, in gridView: PreviewGridView) {
        // Handle
    }
}

// MARK: - PreviewGridViewDataSource
extension MarketViewController: PreviewGridViewDataSource {

    func loadImage(for url: URL, completion: @escaping ((UIImage?) -> ())) {

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }
}

// MARK: - MarketGridCollectionViewDelegate
extension MarketViewController: MarketGridCollectionViewDelegate {
    func didSelect(item: MarketGridPresentable, in gridView: MarketGridCollectionView) {

    }

    func contentSizeDidChange(newSize: CGSize, in gridView: MarketGridCollectionView) {
        marketGridView.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        discoverGridView.headerView = marketGridView
    }
}
