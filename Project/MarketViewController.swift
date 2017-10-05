import UIKit
import Troika
import TroikaDemoKit

class MarketViewController: UIViewController {

    fileprivate lazy var discoverGridView: PreviewGridView = {
        let gridView = PreviewGridView(delegate: self, dataSource: self)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        return gridView
    }()

    fileprivate lazy var marketGridView: MarketGridView = {
        let marketGridView = MarketGridView(delegate: self)
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
        marketGridView.marketGridPresentables = Market.allMarkets

        discoverGridView.previewPresentables = PreviewDataModelFactory.create(numberOfModels: 9)
        discoverGridView.headerView = marketGridView
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
    func didSelect(item: MarketGridPresentable, in gridView: MarketGridView) {

    }

    func contentSizeDidChange(newSize: CGSize, in gridView: MarketGridView) {
        marketGridView.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        discoverGridView.headerView = marketGridView
    }
}
